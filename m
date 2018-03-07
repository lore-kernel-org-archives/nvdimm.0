Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x235.google.com (mail-ot0-x235.google.com
 [IPv6:2607:f8b0:4003:c0f::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B8FC21ED1C63
 for <linux-nvdimm@lists.01.org>; Wed,  7 Mar 2018 10:54:00 -0800 (PST)
Received: by mail-ot0-x235.google.com with SMTP id m22so3059253otf.10
 for <linux-nvdimm@lists.01.org>; Wed, 07 Mar 2018 11:00:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180307185355.4425-1-ross.zwisler@linux.intel.com>
References: <CAPcyv4gSMyVRbVNRubtdQ7_mrY8NpKWwx0p1vdz6j1KLGssSEw@mail.gmail.com>
 <20180307185355.4425-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 7 Mar 2018 11:00:13 -0800
Message-ID: <CAPcyv4iBiXU_9PjRtCvtbr1R8MhQ45wdcUaCbad1XRe4_wWR6g@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ndctl: add filtering based on numa_node
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 7, 2018 at 10:53 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Add support to 'ndctl list' so that we can filter DIMMs, regions and
> namespaces based on numa node.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
> v2: Use NUMA_NO_NODE intead of hard coding -1 (Dan).

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
