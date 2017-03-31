Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 38EDB21A0483E
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 13:39:21 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id r203so73649114oib.3
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 13:39:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1490991738-29637-1-git-send-email-linda.knippers@hpe.com>
References: <1490991738-29637-1-git-send-email-linda.knippers@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 31 Mar 2017 13:39:19 -0700
Message-ID: <CAPcyv4gT53WMaOfQs+WS089+ph3JFqaea2z3Tj9x9Vonh0TM=g@mail.gmail.com>
Subject: Re: [PATCH] ndctl: Add some package dependency information to
 README.md
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 31, 2017 at 1:22 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> Rather than discover the required packages as a result
> of configure failures, provide some hints in advance.
>

Perhaps we should just point people to the "BuildRequires" lines in:

    https://github.com/pmem/ndctl/blob/master/ndctl.spec.in

That's where the list of build dependencies is kept up to date. I'd
rather not track it in two places.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
