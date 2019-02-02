Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com
 [IPv6:2a00:1450:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 445BF211C5757
 for <linux-nvdimm@lists.01.org>; Sat,  2 Feb 2019 11:12:53 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id x85-v6so8589979ljb.2
 for <linux-nvdimm@lists.01.org>; Sat, 02 Feb 2019 11:12:53 -0800 (PST)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com.
 [209.85.208.172])
 by smtp.gmail.com with ESMTPSA id s9-v6sm1924692lja.12.2019.02.02.11.12.50
 for <linux-nvdimm@lists.01.org>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Sat, 02 Feb 2019 11:12:50 -0800 (PST)
Received: by mail-lj1-f172.google.com with SMTP id n18-v6so8544101lji.7
 for <linux-nvdimm@lists.01.org>; Sat, 02 Feb 2019 11:12:50 -0800 (PST)
MIME-Version: 1.0
References: <f0086a11a40fb97503fb559b53dcc94c9f873e32.camel@intel.com>
In-Reply-To: <f0086a11a40fb97503fb559b53dcc94c9f873e32.camel@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 2 Feb 2019 11:12:34 -0800
Message-ID: <CAHk-=wgXh57rgtmSEvbKd69QYtBTRzU3QH36rKcFGiETRj45Sg@mail.gmail.com>
Subject: Re: [GIT PULL] libnvdimm fixes for v5.0-rc4
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jan 26, 2019 at 3:31 PM Williams, Dan J
<dan.j.williams@intel.com> wrote:
>
> Hi Linus, please pull from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-5.0-rc4

Hmm. One more pr-tracker-bot note: going through the pull requests
from the last week, I notice that this one didn't get a pr-tracker
response.

It looks like lkml still hates you, so your pull request email never
made it to the list despite being cc'd. And thus it never makes it to
the lore and pr-tracker-bot infrastructure either.

Have you tried looking into why lkml has that red-hot hatred of your emails?

Because it does seem to be personal - you have pissed off the email
gods some way. Did you get a bounce?

           Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
