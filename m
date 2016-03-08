Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ig0-x244.google.com (mail-ig0-x244.google.com
 [IPv6:2607:f8b0:4001:c05::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8A4F31A1EC8
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 15:31:23 -0800 (PST)
Received: by mail-ig0-x244.google.com with SMTP id ww10so3612814igb.2
 for <linux-nvdimm@lists.01.org>; Tue, 08 Mar 2016 15:31:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457481844.15454.510.camel@hpe.com>
References: <1457460530-17959-1-git-send-email-toshi.kani@hpe.com>
 <CA+55aFy=V-esUXZa2AogS685k+r9PyyNStkZrrUUkWSKvLFUGQ@mail.gmail.com>
 <CAPcyv4gT1RvnEquYXVo7sZscdUrkiWpG-Yvr_EX4=L25397X0g@mail.gmail.com>
 <CA+55aFxPn3J68MsqQd7OVv7jetZjPduP53MFmw2f_-z7=ebpXQ@mail.gmail.com>
 <CAPcyv4i2GwujqK=MDJpSKhvufJprmCV4vmQRpS_UP-n1kau+mg@mail.gmail.com>
 <1457481844.15454.510.camel@hpe.com>
Date: Tue, 8 Mar 2016 15:31:09 -0800
Message-ID: <CA+55aFxJqjvsSz7eeobViGShoJV=FSx9gDbxK_L0WvSnh3xa3w@mail.gmail.com>
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

On Tue, Mar 8, 2016 at 4:04 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
>
> Yes, I prefer the devm semantics.  insert_resource() and remove_resource()
> are not exported interfaces.  So, with devm_add_action(), we still need to
> introduce built-in exported wrappers for insert/remove_resource(), unless
> we change to export them directly.  Since we need to export "something", I
> think it is better to export their devm interfaces.

So I'm coming from the background that

 (a) less code is better

 (b) the "devm_" interface may be convenient, but it has also
traditionally also been a cause of problems and limitations.

Now, the main problems with the devm interface has been either
ordering (which just isn't an issue with resource allocation - it's
been an issue with irqs) or the fact that it can't always be used if
you're not in the right context. So it's "convenient but potentially
inflexible".

And the thing is, I think convenience functions mainly make sense for
places where there are multiple users. If there really is just one or
two (number completely pulled out of my ass), I don't see the point of
a "convenience" function, when we've had the main actual _code_
functionality for over a decade.

So unless there are more users, I'd suggest just exporting the
insert_resource function.

We already export allocate_resource and adjust_resource.

Now, the _one_ argument for devm_insert_resource() is that we do have
"devm_request_resource()".

But quite frankly, just counting the number of devm_request_resource()
calls weakens that argument. There's 7 callers in the whole kernel.
The regular "request_resource()" has 200+ callers.

That may be due to historical reasons, but it may also be at least
partially due to (b) above - there are a number of cases where the
"devm_xyz()" model doesn't work well.

So I think we should see the "devm_xyz()" forms as being a "let's make
things easy for driver writers". I do _not_ think it makes sense for
one-off users.

Now, if it turns out that there are lots of other potential users of
devm_insert_resource(), that would maks all of my arguments go away.

             Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
