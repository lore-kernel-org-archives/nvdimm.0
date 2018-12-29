Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com
 [IPv6:2607:f8b0:4864:20::d43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27FD92063E305
 for <linux-nvdimm@lists.01.org>; Sat, 29 Dec 2018 07:36:13 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id s22so18768098ioc.8
 for <linux-nvdimm@lists.01.org>; Sat, 29 Dec 2018 07:36:13 -0800 (PST)
Date: Sat, 29 Dec 2018 10:36:08 -0500
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Subject: Re: [GIT PULL] libnvdimm for 4.21
Message-ID: <20181229153608.GA21173@pure.paranoia.local>
References: <4880b31d0d32c38a675048be903814a062907125.camel@intel.com>
 <CAHk-=wgMfBXdiaeAxYrdTq9VoaVgN26T8MU7+3EnvJP_e0byuw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHk-=wgMfBXdiaeAxYrdTq9VoaVgN26T8MU7+3EnvJP_e0byuw@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 28, 2018 at 09:57:28PM -0800, Linus Torvalds wrote:
> Hmm.
> 
> This pull request doesn't seem to have gotten an automatic pr-tracker
> reply, even though I pulled it, and even though it was cc'd to lkml.
> 
> Konstantin, any idea why the automation didn't trigger? I'm not seeing
> anything all that odd about it.

As you've noticed, it's not on lore, and it's also not on any other LKML
archive out there (I've checked lkml.org, lkml.iu.edu, marc.info). So,
I'm not sure precisely what happened, but it would appear that despite
the CC in the headers, the mail never actually passed vger.

> Does lkml hate Dan?
> 
> Headers say
> 
>   To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
>   CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
> "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>

I wonder if vger doesn't properly process "CC" headers when both letters
are caps, but it's a very thin guess. As I don't have any access to
vger, I can't shed much more light on this either.

-K

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
