Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 74024202E5305
 for <linux-nvdimm@lists.01.org>; Sat, 30 Jun 2018 11:08:55 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id f17-v6so13298629otl.7
 for <linux-nvdimm@lists.01.org>; Sat, 30 Jun 2018 11:08:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180628221303.3837-1-vishal.l.verma@intel.com>
References: <20180628221303.3837-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 30 Jun 2018 11:08:53 -0700
Message-ID: <CAPcyv4goc_=LiebWsx8LDrcNzHgcCL2KW7PSwJ3--XWBe5L21A@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, test: add start/wait scrub to injection tests
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 28, 2018 at 3:13 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> A number of tests that perform error injection were missing the
> start/wait scrub workaround needed for nfit_test namespaces, causing
> these tests to ocassionally fail. Fix it by starting and waiting for a
> scrub after injection in these remaining places.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good.

Tested-by:  Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
