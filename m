Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 63C19211597FB
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 13:47:39 -0700 (PDT)
Subject: [PATCH v10 04/12] keys: export lookup_user_key to external users
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 26 Sep 2018 13:47:06 -0700
Message-ID: <153799482596.71621.1758872314488292531.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153799466529.71621.10728628542331983376.stgit@djiang5-desk3.ch.intel.com>
References: <153799466529.71621.10728628542331983376.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, ebiggers3@gmail.com, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Export lookup_user_key() symbol in order to allow nvdimm passphrase
update to retrieve user injected keys.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: David Howells <dhowells at redhat.com>
---
 include/linux/key.h          |    3 +++
 security/keys/internal.h     |    2 --
 security/keys/process_keys.c |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index e58ee10f6e58..7099985e35a9 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -346,6 +346,9 @@ static inline key_serial_t key_serial(const struct key *key)
 
 extern void key_set_timeout(struct key *, unsigned);
 
+extern key_ref_t lookup_user_key(key_serial_t id, unsigned long flags,
+				 key_perm_t perm);
+
 /*
  * The permissions required on a key that we're looking up.
  */
diff --git a/security/keys/internal.h b/security/keys/internal.h
index 9f8208dc0e55..9968b21a76dd 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -158,8 +158,6 @@ extern struct key *request_key_and_link(struct key_type *type,
 
 extern bool lookup_user_key_possessed(const struct key *key,
 				      const struct key_match_data *match_data);
-extern key_ref_t lookup_user_key(key_serial_t id, unsigned long flags,
-				 key_perm_t perm);
 #define KEY_LOOKUP_CREATE	0x01
 #define KEY_LOOKUP_PARTIAL	0x02
 #define KEY_LOOKUP_FOR_UNLINK	0x04
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index d5b25e535d3a..ec4fd4531224 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -755,6 +755,7 @@ key_ref_t lookup_user_key(key_serial_t id, unsigned long lflags,
 	put_cred(ctx.cred);
 	goto try_again;
 }
+EXPORT_SYMBOL(lookup_user_key);
 
 /*
  * Join the named keyring as the session keyring if possible else attempt to

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
