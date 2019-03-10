Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com
 [IPv6:2a00:1450:4864:20::141])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8DD46211D3910
 for <linux-nvdimm@lists.01.org>; Sun, 10 Mar 2019 13:02:03 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id u2so1848270lfd.4
 for <linux-nvdimm@lists.01.org>; Sun, 10 Mar 2019 13:02:03 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com.
 [209.85.167.48])
 by smtp.gmail.com with ESMTPSA id f19sm782619lfk.69.2019.03.10.13.01.59
 for <linux-nvdimm@lists.01.org>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Sun, 10 Mar 2019 13:02:00 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id k136so1848100lfg.5
 for <linux-nvdimm@lists.01.org>; Sun, 10 Mar 2019 13:01:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAPcyv4he0q_FdqqiXarp0bXjcggs8QZX8Od560E2iFxzCU3Qag@mail.gmail.com>
In-Reply-To: <CAPcyv4he0q_FdqqiXarp0bXjcggs8QZX8Od560E2iFxzCU3Qag@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 10 Mar 2019 13:01:43 -0700
Message-ID: <CAHk-=wjvmwD_0=CRQtNs5RBh8oJwrriXDn+XNWOU=wk8OyQ5ew@mail.gmail.com>
Subject: Re: [GIT PULL] device-dax for 5.1: PMEM as RAM
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
Cc: Linux MM <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Mar 10, 2019 at 12:54 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Hi Linus, please pull from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
> tags/devdax-for-5.1
>
> ...to receive new device-dax infrastructure to allow persistent memory
> and other "reserved" / performance differentiated memories, to be
> assigned to the core-mm as "System RAM".

I'm not pulling this until I get official Intel clarification on the
whole "pmem vs rep movs vs machine check" behavior.

Last I saw it was deadly and didn't work, and we have a whole "mc-safe
memory copy" thing for it in the kernel because repeat string
instructions didn't work correctly on nvmem.

No way am I exposing any users to something like that.

We need a way to know when it works and when it doesn't, and only do
it when it's safe.

                    Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
