Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 831752095A581
 for <linux-nvdimm@lists.01.org>; Wed, 31 May 2017 09:19:09 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/24] ima/policy: switch to use uuid_t
Date: Wed, 31 May 2017 18:18:18 +0200
Message-Id: <20170531161826.23243-17-hch@lst.de>
In-Reply-To: <20170531161826.23243-1-hch@lst.de>
References: <20170531161826.23243-1-hch@lst.de>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-block@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 security/integrity/ima/ima_policy.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 49fbc3e8f012..9a7c7cbdbe7c 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -61,7 +61,7 @@ struct ima_rule_entry {
 	enum ima_hooks func;
 	int mask;
 	unsigned long fsmagic;
-	u8 fsuuid[16];
+	uuid_t fsuuid;
 	kuid_t uid;
 	kuid_t fowner;
 	bool (*uid_op)(kuid_t, kuid_t);    /* Handlers for operators       */
@@ -244,7 +244,7 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 	    && rule->fsmagic != inode->i_sb->s_magic)
 		return false;
 	if ((rule->flags & IMA_FSUUID) &&
-	    memcmp(rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
+	    memcmp(&rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
 		return false;
 	if ((rule->flags & IMA_UID) && !rule->uid_op(cred->uid, rule->uid))
 		return false;
@@ -711,13 +711,12 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 		case Opt_fsuuid:
 			ima_log_string(ab, "fsuuid", args[0].from);
 
-			if (memchr_inv(entry->fsuuid, 0x00,
-				       sizeof(entry->fsuuid))) {
+			if (uuid_is_null(&entry->fsuuid)) {
 				result = -EINVAL;
 				break;
 			}
 
-			result = uuid_to_bin(args[0].from, (uuid_t *)&entry->fsuuid);
+			result = uuid_parse(args[0].from, &entry->fsuuid);
 			if (!result)
 				entry->flags |= IMA_FSUUID;
 			break;
@@ -1086,7 +1085,7 @@ int ima_policy_show(struct seq_file *m, void *v)
 	}
 
 	if (entry->flags & IMA_FSUUID) {
-		seq_printf(m, "fsuuid=%pU", entry->fsuuid);
+		seq_printf(m, "fsuuid=%pU", &entry->fsuuid);
 		seq_puts(m, " ");
 	}
 
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
