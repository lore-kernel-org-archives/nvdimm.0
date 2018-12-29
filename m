Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com
 [IPv6:2a00:1450:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 38BB22194D3B9
 for <linux-nvdimm@lists.01.org>; Fri, 28 Dec 2018 21:57:48 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id c19-v6so20164284lja.5
 for <linux-nvdimm@lists.01.org>; Fri, 28 Dec 2018 21:57:47 -0800 (PST)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com.
 [209.85.167.48])
 by smtp.gmail.com with ESMTPSA id o5-v6sm8852997ljh.75.2018.12.28.21.57.44
 for <linux-nvdimm@lists.01.org>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Fri, 28 Dec 2018 21:57:44 -0800 (PST)
Received: by mail-lf1-f48.google.com with SMTP id v5so15662623lfe.7
 for <linux-nvdimm@lists.01.org>; Fri, 28 Dec 2018 21:57:44 -0800 (PST)
MIME-Version: 1.0
References: <4880b31d0d32c38a675048be903814a062907125.camel@intel.com>
In-Reply-To: <4880b31d0d32c38a675048be903814a062907125.camel@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Dec 2018 21:57:28 -0800
Message-ID: <CAHk-=wgMfBXdiaeAxYrdTq9VoaVgN26T8MU7+3EnvJP_e0byuw@mail.gmail.com>
Subject: Re: [GIT PULL] libnvdimm for 4.21
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hmm.

This pull request doesn't seem to have gotten an automatic pr-tracker
reply, even though I pulled it, and even though it was cc'd to lkml.

Konstantin, any idea why the automation didn't trigger? I'm not seeing
anything all that odd about it.

[ looks around ]

Oh, I notice that I can't seem to find this message on lore.kernel.org
either, despite seeing that lkml cc when I look at my copy of the
email.

Does lkml hate Dan?

Headers say

  To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
  CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
"linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
  ...
  Date: Fri, 28 Dec 2018 05:04:27 +0000
  Message-ID: <4880b31d0d32c38a675048be903814a062907125.camel@intel.com>

but when I try to look it up on lore.kernel.org, I get:

  Message-ID <4880b31d0d32c38a675048be903814a062907125.camel@intel.com>
  not found

Weird.

               Linus

On Thu, Dec 27, 2018 at 9:04 PM Williams, Dan J
<dan.j.williams@intel.com> wrote:
>
> Hi Linus, please pull from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-4.21
>
> ...to receive the libnvdimm update for 4.21.
[...]
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
