Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 994E92118EF6B
 for <linux-nvdimm@lists.01.org>; Wed, 14 Nov 2018 21:57:30 -0800 (PST)
Date: Wed, 14 Nov 2018 21:56:58 -0800
From: Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [RFC PATCH 0/3] Maintainer Handbook: Subsystem Profile
Message-ID: <20181114215658.78e1908c@silica.lan>
In-Reply-To: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: ksummit-discuss@lists.linuxfoundation.org, Jonathan Corbet <corbet@lwn.net>, Daniel Vetter <daniel.vetter@ffwll.ch>, Ross Zwisler <zwisler@kernel.org>, linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>, linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steve French <stfrench@microsoft.com>, Joe Perches <joe@perches.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>, "Tobin C. Harding" <me@tobin.cc>
List-ID: <linux-nvdimm@lists.01.org>

Em Wed, 14 Nov 2018 20:53:13 -0800
Dan Williams <dan.j.williams@intel.com> escreveu:

> At a recently concluded session at the Linux Plumbers Conference I
> proposed a "Subsystem Profile" as a document that a maintainer can
> provide to set contributor expectations and provide fodder for a
> discussion between maintainers about the merits of different maintainer
> policies.

As discussed at LPC, please don't forget to add a patch teaching
get_maintainers.pl to print the subsystem rules tag (if any) at the
final version of this series.

Cheers,
Mauro
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
