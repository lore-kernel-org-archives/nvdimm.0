Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CAE7A
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 13:30:57 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 2F21A1F444
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 13:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1646919056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=26ZglEtVuutsKx3jPzOl4m2QH94rtcp0IqMltmXg37U=;
	b=HOfRogVj1M62zcnpOhMZQTnJJ5EwKk8XkNq63sIIg3018Snt8LkCHNmNH5gYLjfchyMZ02
	LN1jnzVfyZnAPEb3ZXBZIV4M7aOmX89ZzjdZ1Jd9WMQN8aW6KxsU/hpIQrmjZFobCkVY7o
	qHsrAd5FIuMoiSqN0KRGBjcMyVJXghc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1646919056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type;
	bh=26ZglEtVuutsKx3jPzOl4m2QH94rtcp0IqMltmXg37U=;
	b=vXq8tjCiCP5Dy5VGu03Gruoi20VivNkJBbGY4fm8PXsQWFwiY/gG29nA9gzhQK0VrqnKHg
	wuqpsbzeZvTFDjDQ==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id 27B7EA3B83
	for <nvdimm@lists.linux.dev>; Thu, 10 Mar 2022 13:30:56 +0000 (UTC)
Date: Thu, 10 Mar 2022 14:30:55 +0100
From: Michal Suchanek <msuchanek@suse.de>
To: nvdimm@lists.linux.dev
Subject: [PATCH] meson: make modprobedatadir an option
Message-ID: <20220310133055.GA106731@kunlun.suse.cz>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)

The modprobe.d directory location is hardcoded.

Fixes: 4e5faa1 ("build: Add meson build infrastructure")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 contrib/meson.build | 5 ++++-
 meson_options.txt   | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/contrib/meson.build b/contrib/meson.build
index 4ed3c20..ad63a50 100644
--- a/contrib/meson.build
+++ b/contrib/meson.build
@@ -24,5 +24,8 @@ if bashcompletiondir != 'no'
   install_data('ndctl', rename : 'cxl', install_dir : bashcompletiondir)
 endif
 
-modprobedatadir = get_option('sysconfdir') + '/modprobe.d/'
+modprobedatadir = get_option('modprobedatadir')
+if modprobedatadir == ''
+  modprobedatadir = get_option('modprobedatadir')
+endif
 install_data('nvdimm-security.conf', install_dir : modprobedatadir)
diff --git a/meson_options.txt b/meson_options.txt
index aa4a6dc..3a68460 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -23,3 +23,5 @@ option('pkgconfiglibdir', type : 'string', value : '',
        description : 'directory for standard pkg-config files')
 option('bashcompletiondir', type : 'string',
        description : '''${datadir}/bash-completion/completions''')
+option('modprobedatadir', type : 'string',
+       description : '''${sysconfdir}/modprobe.d/''')
-- 
2.35.1

