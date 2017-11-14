Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8EE292034A86B
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 16:05:15 -0800 (PST)
Received: by mail-oi0-x234.google.com with SMTP id r190so3484363oie.6
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 16:09:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151061749216.21517.4323136981641383849.stgit@djiang5-desk3.ch.intel.com>
References: <151061749216.21517.4323136981641383849.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 Nov 2017 16:09:20 -0800
Message-ID: <CAPcyv4i7VyX0Kyh4-8T7Y2gFKbBFGABLKUq6fqzR4YKWLWM-mw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] ndctl: daxctl: fix mmap size
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 13, 2017 at 3:58 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> The size for mmap needs to be aligned to the region alignment. Fix the
> mapping size so that it satisfy the alignment requirement.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Thanks Dave, applied both.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
