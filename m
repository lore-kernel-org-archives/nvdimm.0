Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC942107A1
	for <nvdimm@lists.linux.dev>; Tue, 22 Nov 2022 17:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669138450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=iMI9Pyh6WEs286zRH2M4856YHZY7Qv3CDC5yTcNM5R4=;
	b=JO+7t8+c8sO4zpZR8hXZHw4shdSA9roMGzGFVsIMl5lggWA7mL/okWvGxMnJMNn52qt+k3
	sfKtFG251dqDA119rSVmiQSFdB4taVxAFa+HLsLX1u+jK9DNb7j0W0eEPW0DznXkpFFXz2
	K+ZzxKX/12TsMV+AMC7G9DSEBp2raPE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-qP5dVW6VPJahWMNpI5NwoQ-1; Tue, 22 Nov 2022 12:34:09 -0500
X-MC-Unique: qP5dVW6VPJahWMNpI5NwoQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E7F9185A794
	for <nvdimm@lists.linux.dev>; Tue, 22 Nov 2022 17:34:09 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CF0447505E
	for <nvdimm@lists.linux.dev>; Tue, 22 Nov 2022 17:34:09 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: nvdimm@lists.linux.dev
Subject: [ndctl patch] security.sh: ensure a user keyring is linked into the session keyring
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Tue, 22 Nov 2022 12:38:01 -0500
Message-ID: <x49a64iq492.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

The restraint test harness is started via a systemd unit file.  In this
environment, there is no user keyring linked into the session keyring:

# keyctl show
Session Keyring
 406647380 --alswrv      0     0  keyring: _ses
 148623625 ----s-rv      0     0   \_ user: invocation_id

As a result, the security.sh test fails.  The logs show:

++ keyctl show
++ grep -Eo '_uid.[0-9]+'
++ head -1
++ cut -d. -f2-
+ uid=
+ '[' '' -ne 0 ']'
/root/rpmbuild/BUILD/ndctl-71.1/test/security.sh: line 245: [: : integer expression expected

and:

+ keyctl search @u encrypted nvdimm:cdab-0a-07e0-feffffff
keyctl_search: Required key not available
+ keyctl search @u user nvdimm-master
keyctl_search: Required key not available
++ hostname
+ '[' -f /etc/ndctl/keys/nvdimm_cdab-0a-07e0-feffffff_storageqe-40.sqe.lab.eng.bos.redhat.com.blob ']'
+ setup_keys
+ '[' '!' -d /etc/ndctl/keys ']'
+ '[' -f /etc/ndctl/keys/nvdimm-master.blob ']'
+ '[' -f /etc/ndctl/keys/tpm.handle ']'
+ dd if=/dev/urandom bs=1 count=32
+ keyctl padd user nvdimm-master @u
++ keyctl search @u user nvdimm-master
+ keyctl pipe 416513477
keyctl_read_alloc: Permission denied
++ err 47
+++ basename /root/rpmbuild/BUILD/ndctl-71.1/test/security.sh
++ echo test/security.sh: failed at line 47
++ '[' -n '' ']'
++ exit 1

To fix this, create a new session keyring and link in the user keyring
from within the script.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/test/security.sh b/test/security.sh
index 34c4977..1aa8488 100755
--- a/test/security.sh
+++ b/test/security.sh
@@ -43,6 +43,9 @@ setup_keys()
 		backup_handle=1
 	fi
 
+	# Make sure there is a session and a user keyring linked into it
+	keyctl new_session
+	keyctl link @u @s
 	dd if=/dev/urandom bs=1 count=32 2>/dev/null | keyctl padd user "$masterkey" @u
 	keyctl pipe "$(keyctl search @u user $masterkey)" > "$masterpath"
 }

