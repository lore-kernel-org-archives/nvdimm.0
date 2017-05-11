Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA5D821A16E54
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 22:15:39 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id w10so18046397oif.0
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 22:15:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170510210131.27157-1-vishal.l.verma@intel.com>
References: <20170510210131.27157-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 10 May 2017 22:15:38 -0700
Message-ID: <CAPcyv4jbSZB-QFywszWpK2ZRODSR-J7t8KkPX-uMKaMRW1RYVQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] libnvdimm: add an atomic vs process context flag
 to rw_bytes
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

On Wed, May 10, 2017 at 2:01 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> nsio_rw_bytes can clear media errors, but this cannot be done while we
> are in an atomic context due to locking within ACPI. From the BTT,
> ->rw_bytes may be called either from atomic or process context depending
> on whether the calls happen during initialization or during IO.
>
> During init, we want to ensure error clearing happens, and the flag
> marking process context allows nsio_rw_bytes to do that. When called
> during IO, we're in atomic context, and error clearing can be skipped.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Thanks Vishal, this one and the next look good to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
