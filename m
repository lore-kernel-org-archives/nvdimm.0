Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id C11F51A1E05
 for <linux-nvdimm@lists.01.org>; Sun, 26 Jun 2016 16:26:10 -0700 (PDT)
Subject: [ndctl PATCH 5/9] ndctl: add libs dependency to spec file
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 26 Jun 2016 16:24:54 -0700
Message-ID: <146698349464.40541.4169309354699196496.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Otherwise ndctl may use an old version of ndctl-libs.  The expectation
is that installing an updated ndctl also includes all the capabilities
of an updated libndctl.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl.spec.in |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index 0aaef03b2e5b..f152bbe44621 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -7,6 +7,8 @@ Group:		System Environment/Base
 Url:		https://github.com/pmem/ndctl
 Source0:	https://github.com/pmem/%{name}/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz
 
+Requires:	LNAME%{?_isa} = %{version}-%{release}
+Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
 BuildRequires:	autoconf
 BuildRequires:	asciidoc
 BuildRequires:	xmlto

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
