Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C5D92211DC09D
 for <linux-nvdimm@lists.01.org>; Fri, 15 Mar 2019 10:33:53 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id k8so7962912oik.8
 for <linux-nvdimm@lists.01.org>; Fri, 15 Mar 2019 10:33:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAPcyv4he0q_FdqqiXarp0bXjcggs8QZX8Od560E2iFxzCU3Qag@mail.gmail.com>
 <CAHk-=wjvmwD_0=CRQtNs5RBh8oJwrriXDn+XNWOU=wk8OyQ5ew@mail.gmail.com>
 <CAPcyv4hafLUr2rKdLG+3SHXyWaa0d_2g8AKKZRf2mKPW+3DUSA@mail.gmail.com>
 <CAHk-=wiTM93XKaFqUOR7q7133wvzNS8Kj777EZ9E8S99NbZhAA@mail.gmail.com>
 <CAPcyv4hMZMuSEtUkKqL067f4cWPGivzn9mCtv3gZsJG2qUOYvg@mail.gmail.com>
 <CAHk-=wgnJd_qY1wGc0KcoGrNz3Mp9-8mQFMDLoTXvEMVtAxyZQ@mail.gmail.com>
In-Reply-To: <CAHk-=wgnJd_qY1wGc0KcoGrNz3Mp9-8mQFMDLoTXvEMVtAxyZQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Mar 2019 10:33:41 -0700
Message-ID: <CAPcyv4iUxDj26_6neOVEg7b6_2SLHKpohv9o6jv95R_RhV1S-g@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux MM <linux-mm@kvack.org>, "Luck, Tony" <tony.luck@intel.com>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 11, 2019 at 5:08 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, Mar 11, 2019 at 8:37 AM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > Another feature the userspace tooling can support for the PMEM as RAM
> > case is the ability to complete an Address Range Scrub of the range
> > before it is added to the core-mm. I.e at least ensure that previously
> > encountered poison is eliminated.
>
> Ok, so this at least makes sense as an argument to me.
>
> In the "PMEM as filesystem" part, the errors have long-term history,
> while in "PMEM as RAM" the memory may be physically the same thing,
> but it doesn't have the history and as such may not be prone to
> long-term errors the same way.
>
> So that validly argues that yes, when used as RAM, the likelihood for
> errors is much lower because they don't accumulate the same way.

Hi Linus,

The question about a new enumeration mechanism for this has been
raised, but I don't expect a response before the merge window closes.
While it percolates, how do you want to proceed in the meantime?

The kernel could export it's knowledge of the situation in
/sys/devices/system/cpu/vulnerabilities?

Otherwise, the exposure can be reduced in the volatile-RAM case by
scanning for and clearing errors before it is onlined as RAM. The
userspace tooling for that can be in place before v5.1-final. There's
also runtime notifications of errors via acpi_nfit_uc_error_notify()
from background scrubbers on the DIMM devices. With that mechanism the
kernel could proactively clear newly discovered poison in the volatile
case, but that would be additional development more suitable for v5.2.

I understand the concern, and the need to highlight this issue by
tapping the brakes on feature development, but I don't see PMEM as RAM
making the situation worse when the exposure is also there via DAX in
the PMEM case. Volatile-RAM is arguably a safer use case since it's
possible to repair pages where the persistent case needs active
application coordination.

Please take another look at merging this for v5.1, or otherwise let me
know what software changes you'd like to see to move this forward. I'm
also open to the idea of just teaching memcpy_mcsafe() to use rep; mov
as if it was always recoverable and relying on the error being mapped
out after reboot if it was not recoverable. At reboot the driver gets
notification of physical addresses that caused a previous crash so
that software can avoid a future consumption.

git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/devdax-for-5.1
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
