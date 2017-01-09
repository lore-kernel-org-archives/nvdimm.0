Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D5D428178D
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jan 2017 13:57:43 -0800 (PST)
Date: Mon, 9 Jan 2017 14:56:37 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH 0/7] introduce 'daxctl list', and 'ndctl list'
 updates
Message-ID: <20170109215636.GA5330@omniknight.lm.intel.com>
References: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 01/06, Dan Williams wrote:
> * The 'ndctl list' command awkwardly prints out all the corresponding
>   device-dax information when a namespace is in 'dax' mode. Conversely if
>   someone is only interested in listing device-dax information they need to
>   contend with libnvdimm data.
> 
>   Introduce a separate daxctl utility with its own 'list' command for this
>   purpose, and make the listing of device-dax data through 'ndctl list'
>   optional (new --device-dax option).

the 'rpmbuild' script was failing as the new daxctl utility wasn't
included in %files in the spec. The following patch fixes that.

8<-----

>From d26a582b4ae9e69a22e52908a5d4bbae0a79717f Mon Sep 17 00:00:00 2001
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Mon, 9 Jan 2017 14:52:34 -0700
Subject: [PATCH] spec: add the new daxctl binary to the spec file

The missing binary was triggering the "installed but unpackaged file
found" check for rpmbuild. Add daxctl to the %files section as we do
want it to be packaged.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl.spec.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index 6453edd..4a22597 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -114,6 +114,7 @@ make check
 %defattr(-,root,root)
 %license util/COPYING licenses/BSD-MIT licenses/CC0
 %{_bindir}/ndctl
+%{_bindir}/daxctl
 %{_mandir}/man1/*
 %{bashcompdir}/
 
-- 
2.9.3


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
