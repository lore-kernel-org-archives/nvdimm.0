Return-Path: <linux-nvdimm-bounces@lists.01.org>
Message-ID: <1485360117.12563.85.camel@perches.com>
Subject: Re: [PATCH] nvdimm: constify device_type structures
From: Joe Perches <joe@perches.com>
Date: Wed, 25 Jan 2017 08:01:57 -0800
In-Reply-To: <alpine.DEB.2.20.1701250745340.2011@hadrien>
References: <1485285847-7006-1-git-send-email-bhumirks@gmail.com>
 <1485311842.12563.50.camel@perches.com>
 <CAPcyv4i7-vT+-VqU2n4bxrtcwrYtJ5rcVg3=bf5gCx-YRe3HkA@mail.gmail.com>
 <1485312569.12563.52.camel@perches.com>
 <alpine.DEB.2.20.1701250745340.2011@hadrien>
Mime-Version: 1.0
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
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bhumika Goyal <bhumirks@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2017-01-25 at 07:49 +0100, Julia Lawall wrote:
> What does the data column actually represent?  I tried size on the .o file
> generated from:
> 
> commit a65f0161f4d69d6738d4821e649448312cd818e2
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Tue Jan 17 15:22:28 2017 +1100
> 
> with CONFIG_X86_64=y and I get:
> 
>    text	   data	    bss	    dec	    hex	filename
>   19726	   3480	     16	  23222	   5ab6	drivers/nvdimm/namespace_devs.o
> 
> but when I run objdump -sh drivers/nvdimm/namespace_devs.o, I find a .data
> segment of size 1008 and a .data.unlikely segment of size 8, which don't
> match up with the results of size.

Likely you have dynamic_debug enabled and you
need to include these additional sections:

	__jump_table
	__verbose

If user_mode_linux is enabled, add sections:

	.fini_array
	.init_array

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
