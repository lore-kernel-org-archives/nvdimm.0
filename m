Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ig0-x244.google.com (mail-ig0-x244.google.com
 [IPv6:2607:f8b0:4001:c05::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E06C91A1EC1
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 12:05:36 -0800 (PST)
Received: by mail-ig0-x244.google.com with SMTP id ir4so3191833igb.3
 for <linux-nvdimm@lists.01.org>; Tue, 08 Mar 2016 12:05:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457460530-17959-1-git-send-email-toshi.kani@hpe.com>
References: <1457460530-17959-1-git-send-email-toshi.kani@hpe.com>
Date: Tue, 8 Mar 2016 12:05:22 -0800
Message-ID: <CA+55aFy=V-esUXZa2AogS685k+r9PyyNStkZrrUUkWSKvLFUGQ@mail.gmail.com>
Subject: Re: [PATCH v2-UPDATE2 3/4] resource: Add device-managed
 insert/remove_resource()
From: Linus Torvalds <torvalds@linux-foundation.org>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 8, 2016 at 10:08 AM, Toshi Kani <toshi.kani@hpe.com> wrote:
>
> Add device-managed implementaions of insert_resource() and
> remove_resouce() functions.

Can we get an example of the users and show how much this would actually help?

insert_resource() is fairly unusual to begin with, and it should
basically *never* be used by a driver at all (it's more of a bus
thing).

The patch doesn't look _wrong_, but it does look potentially largely
pointless. Adding new interfaces to do things that aren't common
enough to worry about is counter-productive, imho.

                 Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
