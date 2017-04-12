Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ozlabs.org (ozlabs.org [103.22.144.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9695F21A04823
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 18:10:19 -0700 (PDT)
Date: Wed, 12 Apr 2017 11:10:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: ZONE_DEVICE and pmem API support for powerpc
Message-ID: <20170412111017.0b94b80b@canb.auug.org.au>
In-Reply-To: <20170411174233.21902-1-oohall@gmail.com>
References: <20170411174233.21902-1-oohall@gmail.com>
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, arbab@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Oliver,

On Wed, 12 Apr 2017 03:42:24 +1000 Oliver O'Halloran <oohall@gmail.com> wrote:
>
> Series is based on next-20170411, but it should apply elsewhere with minor
> fixups to arch_{add|remove}_memory due to conflicts with HMM.  For those

Just to make life fun for you, Andrew has dropped the HMM patches from
his quilt series today (and so they will not be in next-20170412).

-- 
Cheers,
Stephen Rothwell
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
