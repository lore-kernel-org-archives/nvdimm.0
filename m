Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com
 [IPv6:2a00:1450:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 460F2211963D0
 for <linux-nvdimm@lists.01.org>; Sun,  9 Dec 2018 10:35:26 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id g11-v6so7644700ljk.3
 for <linux-nvdimm@lists.01.org>; Sun, 09 Dec 2018 10:35:26 -0800 (PST)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com.
 [209.85.167.53])
 by smtp.gmail.com with ESMTPSA id r26-v6sm1736106lji.25.2018.12.09.10.35.23
 for <linux-nvdimm@lists.01.org>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Sun, 09 Dec 2018 10:35:23 -0800 (PST)
Received: by mail-lf1-f53.google.com with SMTP id a16so6411193lfg.3
 for <linux-nvdimm@lists.01.org>; Sun, 09 Dec 2018 10:35:23 -0800 (PST)
MIME-Version: 1.0
References: <6be0835bf256755375f3b5822bf70d74538d1d6e.camel@intel.com>
 <CAHk-=wgAONwr6pMn+D2OsMZjAB5zNaMWSW5KdTM+L72gGnhV2Q@mail.gmail.com>
 <CAPcyv4jznHRB=BCsm8Y3d-uqDy_OWHSgTsPZoPK-L80FiQftFg@mail.gmail.com>
In-Reply-To: <CAPcyv4jznHRB=BCsm8Y3d-uqDy_OWHSgTsPZoPK-L80FiQftFg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 9 Dec 2018 10:35:07 -0800
Message-ID: <CAHk-=wi5We7PFBqon-Jy1A59CVoGv2kJMJPixPOxm2Bq4JZX7g@mail.gmail.com>
Subject: Re: [GIT PULL] dax fixes for 4.20-rc6
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
To: dan.j.williams@intel.com
Cc: Jan Kara <jack@suse.cz>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Dec 9, 2018 at 10:27 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> I can send a cleanup, do you want one immediately, or is post -rc6 ok?

post-rc6 is fine, I'd rather have the patch tested anyway,

                 Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
