Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8380D1360
	for <nvdimm@lists.linux.dev>; Sun, 10 Apr 2022 12:32:31 +0000 (UTC)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id BE506210EB
	for <nvdimm@lists.linux.dev>; Sun, 10 Apr 2022 12:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1649593943; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=26ZglEtVuutsKx3jPzOl4m2QH94rtcp0IqMltmXg37U=;
	b=c+u2PQcuvWBVCuK5uxomcKWxZdJly/HnMK5fqNIvZkZj+ZLSfNPESViI+P0HrgLayU7ppb
	NNF6peX7rYl5BA9ud/sT7iI7zn+L4HFwm16/BwIn6PmXxScIVN0V/2L/RGzp/8r7ztzviO
	qcbbWqrc0hyM9pyIJ71/O4P28CLHm0o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1649593943;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=26ZglEtVuutsKx3jPzOl4m2QH94rtcp0IqMltmXg37U=;
	b=RR4f5zkX9sVPxJ1jGjiKGbJGtVNVsdcL0CorzycNCa9MpeFuRkAv5FJphvAB6E3EaFsRND
	NeSJuwwZrmbOboCg==
Received: from naga.suse.cz (unknown [10.100.224.114])
	by relay2.suse.de (Postfix) with ESMTP id 9F9CEA3B83;
	Sun, 10 Apr 2022 12:32:23 +0000 (UTC)
From: Michal Suchanek <msuchanek@suse.de>
To: nvdimm@lists.linux.dev
Cc: Michal Suchanek <msuchanek@suse.de>
Subject: [PATCH] meson: make modprobedatadir an option.
Date: Sun, 10 Apr 2022 14:32:05 +0200
Message-Id: <20220410123205.6045-3-msuchanek@suse.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220410123205.6045-1-msuchanek@suse.de>
References: <20220410123205.6045-1-msuchanek@suse.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

