From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] ndctl: delete duplicate -v on "ndctl destroy-namespace
 --help" page
Date: Mon, 27 Jun 2016 19:01:46 +0800
Message-ID: <1467025306-12846-1-git-send-email-yizhan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

"ndctl destroy-namespace --help" page display below two -v option:
[1]-v, --verbose
	Emit debug messages for the namespace operation
[2]-v, --verbose
	Emit debug messages for the namespace destruction operation

Delete the first one which included from xable-namespace-options.txt

Signed-off-by: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 Documentation/ndctl-destroy-namespace.txt | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/ndctl-destroy-namespace.txt b/Documentation/ndctl-destroy-namespace.txt
index ea6d285..3ebb0e8 100644
--- a/Documentation/ndctl-destroy-namespace.txt
+++ b/Documentation/ndctl-destroy-namespace.txt
@@ -14,7 +14,15 @@ include::namespace-description.txt[]
 
 OPTIONS
 -------
-include::xable-namespace-options.txt[]
+<namespace>::
+A 'namespaceX.Y' device name. The keyword 'all' can be specified to carry out
+the operation on every namespace in the system, optionally filtered by region
+(see --region=option)
+
+-r::
+--region=::
+include::xable-region-options.txt[]
+
 -f::
 --force::
 	Unless this option is specified the 'destroy namespace'
@@ -26,7 +34,6 @@ include::xable-namespace-options.txt[]
 --verbose::
 	Emit debug messages for the namespace destruction operation
 
-
 SEE ALSO
 --------
 linkndctl:ndctl-create-namespace[1]
-- 
2.5.0
