Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0AFE7202E5CD0
 for <linux-nvdimm@lists.01.org>; Fri, 13 Oct 2017 16:08:41 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id j126so16519665oia.10
 for <linux-nvdimm@lists.01.org>; Fri, 13 Oct 2017 16:12:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171013001004.14963-7-vishal.l.verma@intel.com>
References: <20171013001004.14963-1-vishal.l.verma@intel.com>
 <20171013001004.14963-7-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Oct 2017 16:12:12 -0700
Message-ID: <CAPcyv4gN8fKgFPUtRLm0NKPsuf_QFkjO0wzGhptU9+f80aP+qg@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 6/6] ndctl/test: add a new unit test for BTT
 error clearing
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 12, 2017 at 5:10 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The new error injection command allows us to inject errors that persist
> through changing the mode of a BTT namespace to 'raw' and back. This
> allows us to test error clearing with a BTT by adding a selective error
> block to the raw namespace, enabling the BTT, and then clearing it via a
> write.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Nice to see this. As for the BTT details I'm going to trust you as the
BTT maintainer, but if any of those are wrong we can handle it later
with incremental fixes.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
