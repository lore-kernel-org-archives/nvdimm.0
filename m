Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ozlabs.org (ozlabs.org [103.22.144.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 670BA22620E6B
 for <linux-nvdimm@lists.01.org>; Sat,  7 Apr 2018 03:58:43 -0700 (PDT)
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v3 3/4] doc/devicetree: Persistent memory region bindings
In-Reply-To: <20180406052116.31483-3-oohall@gmail.com>
References: <20180406052116.31483-1-oohall@gmail.com>
 <20180406052116.31483-3-oohall@gmail.com>
Date: Sat, 07 Apr 2018 20:58:37 +1000
Message-ID: <87zi2fb7vm.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
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
To: Oliver O'Halloran <oohall@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc: devicetree@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Oliver O'Halloran <oohall@gmail.com> writes:
> Add device-tree binding documentation for the nvdimm region driver.
>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
> v2: Changed name from nvdimm-region to pmem-region.
>     Cleaned up the example binding and fixed the overlapping regions.
>     Added support for multiple regions in a single reg.
> v3: Removed platform bus boilerplate from the example.
>     Changed description of the volatile and reg properties
>     to make them more clear.

Thanks.

Acked-by: Michael Ellerman <mpe@ellerman.id.au>

cheers
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
