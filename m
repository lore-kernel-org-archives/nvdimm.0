Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22c.google.com (mail-ot0-x22c.google.com
 [IPv6:2607:f8b0:4003:c0f::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 54E1E20955F26
 for <linux-nvdimm@lists.01.org>; Sat, 24 Feb 2018 19:01:16 -0800 (PST)
Received: by mail-ot0-x22c.google.com with SMTP id l5so3325749otf.9
 for <linux-nvdimm@lists.01.org>; Sat, 24 Feb 2018 19:07:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180222070034.5160-1-qi.fuli@jp.fujitsu.com>
References: <20180222070034.5160-1-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 24 Feb 2018 19:07:18 -0800
Message-ID: <CAPcyv4hos+KMrcusQSKN_7N99Qa_ateLkCUUhizcyctkb4iV2A@mail.gmail.com>
Subject: Re: [RFC PATCH] ndctl, list: add ndctl_filter_opts for sharing filter
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
To: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 21, 2018 at 11:00 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> I wrote a patch for refactoring cmd_list(). It would be appreciated
> if you could check it.
>
> This patch refactors the filter in cmd_list() into ndctl_filter_opts
> object with callback functions. So that the filter used for matching
> a given object can be shared between "list" and "monitor".
>

Thanks for this, it helped clarify what I wanted to see. I'll send out
a patch shortly that goes a bit deeper.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
