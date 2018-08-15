Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB53E210EB11F
 for <linux-nvdimm@lists.01.org>; Wed, 15 Aug 2018 10:32:23 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2] ndctl, docs: Use asciidoctor by default
Date: Wed, 15 Aug 2018 11:32:18 -0600
Message-Id: <20180815173218.11423-1-vishal.l.verma@intel.com>
In-Reply-To: <20180814230555.3498-3-vishal.l.verma@intel.com>
References: <20180814230555.3498-3-vishal.l.verma@intel.com>
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

The asciidoc built documentation has several formatting artifacts (e.g.
Using asciidoctor for the build fixes this, so switch to it as the
default. This can still be disabled during configure using
"--disable-asciidoctor"

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 configure.ac  | 2 +-
 ndctl.spec.in | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

v2: update the build dependency in the spec file

diff --git a/configure.ac b/configure.ac
index 00178bb..7bfe5a7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -45,7 +45,7 @@ AM_CONDITIONAL([ENABLE_DOCS], [test "x$enable_docs" = "xyes"])
 AC_ARG_ENABLE([asciidoctor],
 	AS_HELP_STRING([--enable-asciidoctor],
 	[use asciidoctor for documentation build]),
-	[], enable_asciidoctor=no)
+	[], enable_asciidoctor=yes)
 AM_CONDITIONAL([USE_ASCIIDOCTOR], [test "x$enable_asciidoctor" = "xyes"])
 if test "x$enable_asciidoctor" = "xyes"; then
 	asciidoc="asciidoctor"
diff --git a/ndctl.spec.in b/ndctl.spec.in
index 062aafb..b782aea 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -10,7 +10,7 @@ Source0:	https://github.com/pmem/%{name}/archive/v%{version}.tar.gz#/%{name}-%{v
 Requires:	LNAME%{?_isa} = %{version}-%{release}
 Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
 BuildRequires:	autoconf
-BuildRequires:	asciidoc
+BuildRequires:	rubygem-asciidoctor
 BuildRequires:	xmlto
 BuildRequires:	automake
 BuildRequires:	libtool
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
