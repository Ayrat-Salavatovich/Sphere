FROM base/archlinux

RUN pacman-key --init
RUN pacman-key --populate archlinux
RUN pacman-key --refresh-keys
RUN pacman -Sy archlinux-keyring --noprogressbar --noconfirm
RUN pacman -S --force openssl --noconfirm
RUN pacman -S pacman --noprogressbar --noconfirm
RUN pacman-db-upgrade
RUN pacman -Syyu gcc curl postgresql bison make --noprogressbar --noconfirm

# cleanup
RUN pacman -Sc --noconfirm
RUN pacman -Scc --noconfirm

ENV PERLBREW_ROOT /opt/perl5

RUN curl -L http://install.perlbrew.pl | bash
RUN source $PERLBREW_ROOT/etc/bashrc && perlbrew install --threads perl-5.24.0

RUN echo '# PERLBREW' >> /etc/profile
RUN echo "export PATH=$PERLBREW_ROOT/bin:\$PATH" >> /etc/profile
RUN echo '' >> /etc/profile
