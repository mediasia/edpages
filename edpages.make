; $Id$

core = "6.x"
api = "2"
 
;Contrib projects 

projects[features][subdir] = "contrib"
;projects[features][version] = "2.0"
projects[strongarm][subdir] = "contrib"
projects[ctools][subdir] = "contrib"
projects[uuid][subdir] = "contrib"
projects[uuid_features][subdir] = "contrib"
projects[context][subdir] = "contrib"
projects[schema][subdir] = "contrib"
projects[admin_menu][subdir] = "contrib"
projects[pathauto][subdir] = "contrib"
projects[views][subdir] = "contrib"
projects[cck][subdir] = "contrib"
projects[filefield][subdir] = "contrib"
projects[imagefield][subdir] = "contrib"
projects[imagecache][subdir] = "contrib"
projects[imageapi][subdir] = "contrib"
projects[webform][subdir] = "contrib"
projects[webformblock][subdir] = "contrib"
projects[menutrails][subdir] = "contrib"
projects[menu_block][subdir] = "contrib"
projects[nice_menus][subdir] = "contrib"
projects[auto_menutitle][subdir] = "contrib"
projects[ctm][subdir] = "contrib"
projects[devel][subdir] = "contrib"
projects[location][subdir] = "contrib"
projects[advanced_help][subdir] = "contrib"
projects[gmap][subdir] = "contrib"
projects[better_formats][subdir] = "contrib"
projects[helpinjector][subdir] = "contrib"
projects[image][subdir] = "contrib"
projects[panels][subdir] = "contrib"
projects[wysiwyg][subdir] = "contrib"
projects[custom_breadcrumbs][subdir] = "contrib"
projects[image_fupload][subdir] = "contrib"
projects[token][subdir] = "contrib"
;projects[librairies][subdir] = "contrib"
;projects[total_control][subdir] = "contrib"


; themes
projects[] = zen
projects[] = rubik
projects[] = tao

projects[mao][type] = theme
projects[mao][download][type] = "git"
projects[mao][download][url] = "git://github.com/mediasia/mao.git"

; features

projects[news][subdir] = "features"
projects[news][type] = module
projects[news][download][type] = "git"
projects[news][download][url] = "git://github.com/mediasia/news.git"

projects[locations][subdir] = "features"
projects[locations][type] = module
projects[locations][download][type] = "git"
projects[locations][download][url] = "git://github.com/mediasia/locations.git"

projects[page][subdir] = "features"
projects[page][type] = module
projects[page][download][type] = "git"
projects[page][download][url] = "git://github.com/mediasia/page.git"

projects[wysiwyg_config][subdir] = "features"
projects[wysiwyg_config][type] = module
projects[wysiwyg_config][download][type] = "git"
projects[wysiwyg_config][download][url] = "git://github.com/mediasia/wysiwyg_config.git"



