<?php

// v0.2

/**
* Return a description of the profile for the initial installation screen.
*
* @return
*   An array with keys 'name' and 'description' describing this profile.
*/
function edpages_profile_details() {
  return array(
    'name' => 'Ed pages profile',
    'description' => 'This profile will install ed pages distrib',
  );
}


/**
* Return an array of the modules to be enabled when this profile is installed.
*
* @return
*  An array of modules to be enabled.
*/
function edpages_profile_modules() {
  return array(
    // Enable core modules first.
    'block', 'filter', 'node', 'system', 'user', 'path', 'menu', 'php', 'taxonomy',
    
    // Import, export, variables and overrides modules
    'features', 'strongarm', 'ctools', 'uuid', 'uuid_features',

    // Abstraction modules
    'context', 'context_ui', 'schema',
    
    // Admin modules
    'admin_menu',
    
    // Path modules
    'pathauto',
    
    // Views related modules
    'views', 'views_ui',
    
    // Content related modules
    'content', 'filefield', 'imagefield', 
    
    // Image processing modules
    'imagecache', 'imagecache_ui', 'imageapi', 'imageapi_gd',
    
    // Content editing related modules
    
    // Forms
    'webform', 'webformblock',
    
    // Menu related modules
    'menutrails', 'menu_block', 'nice_menus', 'auto_menutitle', 'ctm',
    
    // Developper modules
    'devel', 'devel_generate',
    
    // Features
    'page', 'wysiwyg_config',

  );
}


/**
 * Implementation of hook_profile_task_list().
 */
function edpages_profile_task_list() {
  return array(
    'edpages-configure' => st('Edpages pages configuration'),
  );
}


/**
 * Implementation of hook_profile_tasks().
 */
function edpages_profile_tasks(&$task, $url) {
  global $install_locale;

  // Clear caches.
  drupal_flush_all_caches();

  // Enable the right theme. This must be handled after drupal_flush_all_caches()
  // which rebuilds the system table based on a stale static cache,
  // blowing away our changes.
  _edpages_system_theme_data();
  
  // Reset theme configuration
  db_query("UPDATE {system} SET status = 0 WHERE type = 'theme'");
  
  // Set default theme
  db_query("UPDATE {system} SET status = 1 WHERE type = 'theme' AND name = 'mao'");
  db_query("UPDATE {blocks} SET region = '' WHERE theme = 'mao'");
  variable_set('theme_default', 'mao');
  
  // Set admin theme
  db_query("UPDATE {system} SET status = 1 WHERE type = 'theme' AND name = 'rubik'");
  db_query("UPDATE {blocks} SET region = '' WHERE theme = 'rubik'");
  variable_set('admin_theme', 'rubik');

  // Configure WYSIWYG with CKeditor on full filter
  db_query("INSERT INTO {wysiwyg} (format, editor) VALUES (%d, '%s')", 1, '');
  db_query("INSERT INTO {wysiwyg} (format, editor) VALUES (%d, '%s')", 2, 'ckeditor');
  db_query("INSERT INTO {wysiwyg} (format, editor) VALUES (%d, '%s')", 3, '');

  $task = 'finished';
  
  return $output;

}

/**
 * Finished callback for the modules install batch.
 *
 * Advance installer task to language import.
 */

function _edpages_profile_batch_finished ($success, $results) {
  variable_set('install_task', 'edpages-configure');
}

function edpages_form_alter(&$form, $form_state, $form_id) {
  if ($form_id == 'install_configure') {
    $form['site_information']['site_name']['#default_value'] = 'Edpages site';   // Site name
    $form['site_information']['site_mail']['#default_value'] = 'admin@'. $_SERVER['HTTP_HOST'];  // Site email address
    $form['admin_account']['account']['name']['#default_value'] = 'admin';  // Site admin username
    $form['admin_account']['account']['mail']['#default_value'] = 'spacedoud@gmail.com'; // Site admin email address
    $form['admin_account']['account']['pass']['#post_render'] = array('_edpages_set_pass'); // Site admin email address
    $form['server_settings']['update_status_module']['#default_value'] = array(0 => 0); // Site admin email address
  }
}

/**
 * Returns admin pass to be stored by default in the setting page administration
 */
function _edpages_set_pass (&$form) {
  return str_replace('type="password"', 'type="password" value="abcd1243"', $form);
}



/**
 * Reimplementation of system_theme_data(). The core function's static cache
 * is populated during install prior to active install profile awareness.
 * This workaround makes enabling themes in profiles/managingnews/themes possible.
 */
function _edpages_system_theme_data() {
  global $profile;
  $profile = 'edpages';

  $themes = drupal_system_listing('\.info$', 'themes');
  $engines = drupal_system_listing('\.engine$', 'themes/engines');

  $defaults = system_theme_default();

  $sub_themes = array();
  foreach ($themes as $key => $theme) {
    $themes[$key]->info = drupal_parse_info_file($theme->filename) + $defaults;

    if (!empty($themes[$key]->info['base theme'])) {
      $sub_themes[] = $key;
    }

    $engine = $themes[$key]->info['engine'];
    if (isset($engines[$engine])) {
      $themes[$key]->owner = $engines[$engine]->filename;
      $themes[$key]->prefix = $engines[$engine]->name;
      $themes[$key]->template = TRUE;
    }

    // Give the stylesheets proper path information.
    $pathed_stylesheets = array();
    foreach ($themes[$key]->info['stylesheets'] as $media => $stylesheets) {
      foreach ($stylesheets as $stylesheet) {
        $pathed_stylesheets[$media][$stylesheet] = dirname($themes[$key]->filename) .'/'. $stylesheet;
      }
    }
    $themes[$key]->info['stylesheets'] = $pathed_stylesheets;

    // Give the scripts proper path information.
    $scripts = array();
    foreach ($themes[$key]->info['scripts'] as $script) {
      $scripts[$script] = dirname($themes[$key]->filename) .'/'. $script;
    }
    $themes[$key]->info['scripts'] = $scripts;

    // Give the screenshot proper path information.
    if (!empty($themes[$key]->info['screenshot'])) {
      $themes[$key]->info['screenshot'] = dirname($themes[$key]->filename) .'/'. $themes[$key]->info['screenshot'];
    }
  }

  foreach ($sub_themes as $key) {
    $themes[$key]->base_themes = system_find_base_themes($themes, $key);
    // Don't proceed if there was a problem with the root base theme.
    if (!current($themes[$key]->base_themes)) {
      continue;
    }
    $base_key = key($themes[$key]->base_themes);
    foreach (array_keys($themes[$key]->base_themes) as $base_theme) {
      $themes[$base_theme]->sub_themes[$key] = $themes[$key]->info['name'];
    }
    // Copy the 'owner' and 'engine' over if the top level theme uses a
    // theme engine.
    if (isset($themes[$base_key]->owner)) {
      if (isset($themes[$base_key]->info['engine'])) {
        $themes[$key]->info['engine'] = $themes[$base_key]->info['engine'];
        $themes[$key]->owner = $themes[$base_key]->owner;
        $themes[$key]->prefix = $themes[$base_key]->prefix;
      }
      else {
        $themes[$key]->prefix = $key;
      }
    }
  }

  // Extract current files from database.
  system_get_files_database($themes, 'theme');
  db_query("DELETE FROM {system} WHERE type = 'theme'");
  foreach ($themes as $theme) {
    $theme->owner = !isset($theme->owner) ? '' : $theme->owner;
    db_query("INSERT INTO {system} (name, owner, info, type, filename, status, throttle, bootstrap) VALUES ('%s', '%s', '%s', '%s', '%s', %d, %d, %d)", $theme->name, $theme->owner, serialize($theme->info), 'theme', $theme->filename, isset($theme->status) ? $theme->status : 0, 0, 0);
  }
}



?>