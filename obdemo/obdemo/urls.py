from django.conf.urls.defaults import *
from obadmin import admin

admin.autodiscover()

urlpatterns = patterns(

    '',

    # EB admin site. Also need 2 additonal apps in settings.INSTALLED_APPS:
    # 'everyblock.admin' and 'everyblock.staticmedia'.
    #(r'^ebadmin/', include('everyblock.admin.urls')),

    # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
    # to INSTALLED_APPS to enable admin documentation:
    # (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    (r'^admin/', include(admin.site.urls)),

    (r'^api/newsitems.geojson/$', 'obdemo.views.newsitems_geojson'),
    (r'^locations/([-a-z0-9]{1,32})/([-a-z0-9]{1,32})/place.kml$',
     'obdemo.views.place_kml',
     {'place_type': 'location'}),

    (r'^disclaimer', 'django.views.generic.simple.direct_to_template',
     {'template': 'disclaimer.html'}),

    (r'^geotagger/$', 'obdemo.views.geotagger_ui'),

    # geotagger api
    (r'^', include('ebdata.geotagger.urls')),

    # ebpub provides all the UI for an openblock site.
    (r'^', include('ebpub.urls')),
    

    

)
