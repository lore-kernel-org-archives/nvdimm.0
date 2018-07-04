Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1DDA3210C0CEE
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 07:32:48 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id w126-v6so11099327oie.7
 for <linux-nvdimm@lists.01.org>; Wed, 04 Jul 2018 07:32:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D9FFE20C522965449E182ACE73889AEBF4F2E02E@IRSMSX101.ger.corp.intel.com>
References: <D9FFE20C522965449E182ACE73889AEBF4F2E02E@IRSMSX101.ger.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 4 Jul 2018 07:32:46 -0700
Message-ID: <CAPcyv4gw12anx4tFqG1zeFjS-Be8kxVgXDqNHE5U4eES-=UOBQ@mail.gmail.com>
Subject: Re: [BUG] Injecting bad blocks in the nfit_test module does not work
 with kernel v4.17.4 + ndctl v61.1
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
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: "Li, ZhijianX" <zhijianx.li@intel.com>, Slusarz,, "Piotr  <piotr.balcer@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 4, 2018 at 5:45 AM, Dorau, Lukasz <lukasz.dorau@intel.com> wrote:
> Hi,
>
>
>
> This is a bug report:  injecting bad blocks in the nfit_test module does not
> work with the kernel v4.17.4 (the latest stable at this moment) and ndctl
> v61.1:
>

Sorry, yes, this is a known issue. There is no fix on the near
horizon, this is a casualty of the ARS rework we did in the kernel
between v4.16 and v4.17. More details here:

https://github.com/pmem/issues/issues/897#issuecomment-402495154
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
