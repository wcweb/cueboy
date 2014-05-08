import sys
if len(sys.argv) < 3 or len(sys.argv) > 3:
    print """
        This script takes exactly two arguments: 
        the original file and the image path.
        """
else:
    import base64, re

    org = sys.argv[1]
    org_file = open(org, 'r')
    css = org_file.read()
    css_base = sys.argv[2]
    extensions = {
        'png': 'image/png',
        'gif': 'image/gif',
    }
    for ext in extensions:
        regex = re.compile('(\.*\/*)([a-zA-Z0-9-_/]+)\.%s' % ext)
        matches = regex.finditer(css)
        if matches:
            for m in matches:
                img_name = m.group(1) + m.group(2) + '.' + ext
                img_file = css_base + '/' + img_name
                try:
                    img_text = base64.b64encode(open(img_file,'rb').read())
                    css = css.replace(img_name, 'data:%s;base64,%s' % (extensions[ext], img_text))
                except IOError:
                    print "%s does not exist" % img_file
        else:
            print "No %s images found." % ext

    org_file.close()
    dest_file = open(org, 'w')
    dest_file.write(css)
    dest_file.close()
