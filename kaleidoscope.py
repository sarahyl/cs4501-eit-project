# References for MediaPipe Webcam Handtracking: 
# https://developers.google.com/mediapipe/solutions/vision/hand_landmarker 
# https://mediapipe.readthedocs.io/en/latest/solutions/hands.html

# References for Serial Communication:
# https://pyserial.readthedocs.io/en/latest/pyserial_api.html 
# https://projecthub.arduino.cc/ansh2919/serial-communication-between-python-and-arduino-663756 

import cv2
import mediapipe as mp
import numpy as np
import socket
import struct
import time
# import serial

HOST = '127.0.0.1'
PORT = 5204
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Initialize MediaPipe hands module
mp_drawing = mp.solutions.drawing_utils
mp_hands = mp.solutions.hands

# Initialize video capture
cap = cv2.VideoCapture(0)

# Initialize serial connection
# ser = serial.Serial(port='COM10',  baudrate=115200)  # Adjust COM port accordingly

# Function to extract fingertip coordinates
def extract_fingertip_coordinates(landmarks):
    for i in range(len(landmarks.landmark)):
        if i == 8:  # Index finger tip landmark
            x = float(landmarks.landmark[i].x * 640)  # Scale x coordinate
            y = float(landmarks.landmark[i].y * 480)  # Scale y coordinate
            return x, y
    return None, None
try:
    # Connect to the Processing server
    client_socket.connect((HOST, PORT))
    with mp_hands.Hands(
        min_detection_confidence=0.5,
        min_tracking_confidence=0.5) as hands:
        while cap.isOpened():
            ret, frame = cap.read()
            if not ret:
                break

            # Convert BGR to RGB
            frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

            # Process the frame
            results = hands.process(frame_rgb)

            if results.multi_hand_landmarks:
                for hand_landmarks in results.multi_hand_landmarks:
                    # Draw hand landmarks on the frame
                    mp_drawing.draw_landmarks(frame, hand_landmarks, mp_hands.HAND_CONNECTIONS)

                    # Extract fingertip coordinates
                    x, y = extract_fingertip_coordinates(hand_landmarks)

                    # Send a message to the Processing server
                    ## NOTE: In this case, we are sending 4 float values, you can change the number of values and the format as needed
                    # float_values = [1.23, 2.34, 3.45, 4.56] # Sample Values
                    float_values = [x, y] # Sample Values
                    packed_data = struct.pack('!2f', *float_values) # The '4' represents the number of values to pack, 'f' represents the format (float), and the '!' is used to ensure network byte order (leave this one as is unless you NEED to change it).
                    client_socket.sendall(packed_data)
                    
                    # Add a small delay if needed
                    # time.sleep(0.1)
                # Send coordinates over serial
                # if x is not None and y is not None:
                #     ser.write(f"{x},{y}\n".encode())  # Send coordinates as string
                # print(x,y)

            cv2.imshow('MediaPipe Hands', frame)

            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
finally:
    # Close the connection when done
    client_socket.close()

# Release the VideoCapture object, close windows, and close serial connection
cap.release()
cv2.destroyAllWindows()
# ser.close()
