$bootstrap_symlinks=hiera('bootstrap_symlinks')
create_resources(file, $bootstrap_symlinks, {ensure=>'link'})