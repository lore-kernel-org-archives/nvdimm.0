Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F9B22119A47F
 for <linux-nvdimm@lists.01.org>; Tue, 11 Dec 2018 12:25:34 -0800 (PST)
Subject: [PATCH v13 03/17] keys: Export lookup_user_key to external users
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 11 Dec 2018 13:25:33 -0700
Message-ID: <154455993330.26509.106635801589937558.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154455914081.26509.7988630204184570351.stgit@djiang5-desk3.ch.intel.com>
References: <154455914081.26509.7988630204184570351.stgit@djiang5-desk3.ch.intel.com>
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
Cc: dhowells@redhat.com, zohar@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Export lookup_user_key() symbol in order to allow nvdimm passphrase
update to retrieve user injected keys.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
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
index 74cb0ff42fed..479909b858c7 100644
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
