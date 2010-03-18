var Dovetail = Class.create();

Dovetail.prototype = {
  
  showing_admin:false,
  showing_section:null,
  animating:false,
  ajax_path_prefix:'',
  open_height:'',
  closed_height:'',
  
  initialize:function(prefix_path,open_height,closed_height) {
    this.ajax_path_prefix = prefix_path;
    this.open_height = open_height;
    this.closed_height = closed_height;
  },
  
  // Show the admin bar
  showAdmin:function(id) {
    if (!this.animating) {
      this.animating = true;
      if (!this.showing_admin) {                // admin is closed so open it
        this.openAdmin(id);
      } else if (this.showing_section == id) {  // clicking the same section that's already open closes the admin
        this.closeAdmin(id);
      } else {                                  // The admin is already open, switch to a different section
        this.switchSection(id);
      }
      setTimeout(function() { this.animating = false }.bind(this), 1000); // wait 1 second for animations to stop before saying we're done
    }
  },
  
  openAdmin:function(id) {
    this.tellServerAdminState('open',id);
    this.hideAllSections();
    $(id).show();
    $('admin').morph({'height':this.open_height});
    this.showing_section = id;
    this.showing_admin = true;
  },
  
  closeAdmin:function(id) {
    this.tellServerAdminState('close');
    $('admin').morph({'height':this.closed_height});
    this.showing_section = null;
    this.showing_admin = false;
  },
  
  switchSection:function(id) {
    this.tellServerAdminState('open',id)
    new Effect.Fade(this.showing_section,{'duration':0.5});
    new Effect.Appear(id,{'delay':0.5});
    this.showing_section = id;
  },
  
  hideAdmin:function() {
    if (!this.animating && this.showing_admin) {
      // this.animating = true;
      $('admin').morph({'height':this.closed_height});
      this.showing_section = null;
      this.showing_admin = false;
    }
  },
  
  changeVariant:function(id,obj,prefix) {
    new Ajax.Request( this.requestPath('change_variant',id),
                      { asynchronous:true,
                        onSuccess:function(r) {
                          $('template_stylesheet').href = r.responseText;
                          $('appearance').down('li.current').removeClassName('current');
                          obj.addClassName('current');
                        }
                      });
  },
  
  addPage:function(name,slug) {
    
  },
  
  tellServerAdminState:function(state,id) {
    new Ajax.Request( this.requestPath(state+'_admin',id),
                      { asynchronous:true });
  },
  
  hideAllSections:function() {
    $$('#sections .section').each(function(section) { section.hide() }); 
  },
  
  requestPath:function(action,id) {
    var path = this.ajax_path_prefix + '/' + action
    if (id != undefined) { path += '/' + id }
    return path
  }
  
}
