Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 2328E1A1DFA
 for <linux-nvdimm@lists.01.org>; Mon, 23 May 2016 14:08:46 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 1/2] ndctl: fix a segfault in parse-options.c
Date: Mon, 23 May 2016 15:07:55 -0600
Message-Id: <1464037676-5776-2-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1464037676-5776-1-git-send-email-vishal.l.verma@intel.com>
References: <1464037676-5776-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Running something like ndctl create-namespace --list-cmds
would reliably segfault ndctl due to a null pointer dereference.

Add a check before the dereference to fix it.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 util/parse-options.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/util/parse-options.c b/util/parse-options.c
index f170eb0..387eecd 100644
--- a/util/parse-options.c
+++ b/util/parse-options.c
@@ -472,8 +472,9 @@ int parse_options_subcommand(int argc, const char **argv, const struct option *o
 		}
 		exit(130);
 	case PARSE_OPT_LIST_SUBCMDS:
-		for (int i = 0; subcommands[i]; i++)
-			printf("%s ", subcommands[i]);
+		if (subcommands)
+			for (int i = 0; subcommands[i]; i++)
+				printf("%s ", subcommands[i]);
 		exit(130);
 	default: /* PARSE_OPT_UNKNOWN */
 		if (ctx.argv[0][1] == '-') {
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
