import random
import time
import sys
import logging 

def main():
    while True:
        try:
            # Simulate some work
            time.sleep(random.uniform(0.1, 1))  # Wait for a random time
            logger.info('Doing something, everything looks fine here...')
        except Exception as e:
            logging.exception("An error occurred") # Log the exception with traceback
            sys.exit(1)

        print("Continuing execution...")


if __name__ == "__main__":
    main()

