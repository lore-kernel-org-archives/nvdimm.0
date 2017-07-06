Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1754C20958969
 for <linux-nvdimm@lists.01.org>; Wed,  5 Jul 2017 19:54:44 -0700 (PDT)
Date: Thu, 6 Jul 2017 04:56:21 +0200
From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH v4 12/16] libnvdimm, nfit: enable support for volatile
 ranges
Message-ID: <20170706025621.GA15122@lst.de>
References: <d545a1ea-0199-7462-58c5-067cdc22cacc@hpe.com>
 <CAPcyv4gnkpWXJ7jOJ7r0kWLKoLfuqJzdHTjANBUPztyTWUrOjA@mail.gmail.com>
 <595589CF.5010605@hpe.com>
 <CAPcyv4iTaXc92ggQcBnqJ=P0jsMF9HhnV4nAsr1Qos4pjrRDLA@mail.gmail.com>
 <1499297819.2042.5.camel@hpe.com>
 <CAPcyv4ixQFNT_8tGFyf2ABqxpPd-jmtXKVeLBRdzBW12u3TJbg@mail.gmail.com>
 <1499303324.2042.7.camel@hpe.com>
 <CAPcyv4gL25svXg=7dmftmxMoqd7Fns_JV1WsGx_iFXRGBJT-CA@mail.gmail.com>
 <20170706021118.GA14468@lst.de>
 <CAOSf1CHFsYFuTTKVQahbBoNrEq7Oo3=iigEzBaQviRgDrmEg3w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOSf1CHFsYFuTTKVQahbBoNrEq7Oo3=iigEzBaQviRgDrmEg3w@mail.gmail.com>
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
To: Oliver <oohall@gmail.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 06, 2017 at 12:53:13PM +1000, Oliver wrote:
> The main use case is provisioning install media for bare metal
> servers. Traditionally that's been handled by having the BMC emulate a
> USB CD drive. Unfortunately, most BMCs have limited CPU, limited
> memory and a wet-string network connection so a host based alternative
> is nice to have.

If they are CD replacement they should be marked as read-only, which
would solve any concerns about them being volatile or not.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
