FROM jackfirth/racket

RUN raco pkg install --auto rackunit

RUN apt-get update && \
    apt-get install -y xvfb

ENV DISPLAY=:99.0


# FROM ubuntu

# RUN apt-get update && apt-get install -y racket
# RUN raco pkg install --auto beautiful-racket

# RUN raco pkg install --batch --deps search-auto txexpr


# FROM debian

# RUN apt-get update && \
#     apt-get install -y wget sqlite3 && \
#     rm -rf /var/lib/apt/lists/*

# ENV RACKET_VERSION 6.2
# ENV RACKET_INSTALLER_URL http://mirror.racket-lang.org/installers/$RACKET_VERSION/racket-$RACKET_VERSION-x86_64-linux-debian-squeeze.sh

# RUN wget --output-document=racket-install.sh $RACKET_INSTALLER_URL && \
#     echo "yes\n1\n" | /bin/bash racket-install.sh && \
#     rm racket-install.sh

# # Set the working directory to /app
# WORKDIR /app

# # Copy the current directory contents into the container at /app
# COPY . /app

# # Install any needed packages specified in requirements.txt
# # RUN pip install --trusted-host pypi.python.org -r requirements.txt

# # Make port 80 available to the world outside this container
# # EXPOSE 80

# # Run app.py when the container launches
# CMD ["racket", "03.rkt"]
