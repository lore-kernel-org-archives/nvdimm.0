Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22d.google.com (mail-ot0-x22d.google.com
 [IPv6:2607:f8b0:4003:c0f::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CAB4A21ED1C5C
 for <linux-nvdimm@lists.01.org>; Wed,  7 Mar 2018 10:19:13 -0800 (PST)
Received: by mail-ot0-x22d.google.com with SMTP id w38so2947913ota.8
 for <linux-nvdimm@lists.01.org>; Wed, 07 Mar 2018 10:25:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180307180237.9289-2-ross.zwisler@linux.intel.com>
References: <20180307180237.9289-1-ross.zwisler@linux.intel.com>
 <20180307180237.9289-2-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 7 Mar 2018 10:25:28 -0800
Message-ID: <CAPcyv4gqX31dD=d8+YvsXxzPJBMzLWGeE8w8X_02gfWsU9nDcw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ndctl: add numa_node support for regions
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

On Wed, Mar 7, 2018 at 10:02 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Add an API for getting the numa node of a given region and add a numa_node
> field to the "ndctl list" region output.
>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
