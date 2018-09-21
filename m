Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 916FA21131DDC
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 16:52:02 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id k16-v6so59388oik.6
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 16:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <153549646600.4089.2626014553500613547.stgit@djiang5-desk3.ch.intel.com>
 <153549632073.4089.3609134467249378610.stgit@djiang5-desk3.ch.intel.com>
 <17433.1537572050@warthog.procyon.org.uk>
 <58be84f5-c36c-1868-8bd3-06a09d6b59c6@intel.com>
In-Reply-To: <58be84f5-c36c-1868-8bd3-06a09d6b59c6@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Sep 2018 16:51:51 -0700
Message-ID: <CAPcyv4gjAbLo5rPUO_M8vJ_EE-Ac4UNcmwZSfYt5YeMr8zC66w@mail.gmail.com>
Subject: Re: [PATCH v8 05/12] nfit/libnvdimm: add unlock of nvdimm support for
 Intel DIMMs
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "Schofield, Alison" <alison.schofield@intel.com>, Kees Cook <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Eric Biggers <ebiggers3@gmail.com>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 21, 2018 at 4:27 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
>
>
> On 09/21/2018 04:20 PM, David Howells wrote:
> > Dave Jiang <dave.jiang@intel.com> wrote:
> >
> >> +    depends on KEYS
> >
> > That needs to be in patch 2 where you create a keyring.
> >
> >> +    char desc[NVDIMM_KEY_DESC_LEN + strlen(NVDIMM_PREFIX)];
> >
> > You should be using sizeof() not strlen() and do you need + 1 for the NUL
> > char?
> >
> >> +    sprintf(desc, "%s%s", NVDIMM_PREFIX, nvdimm->dimm_id);
> >
> > NVDIMM_PREFIX is a constant string.  I would recommend either declaring it as
> > a const char[] or just sticking it in the format string in place of the %s:
> >
> >       sprintf(desc, NVDIMM_PREFIX "%s", nvdimm->dimm_id);
> >
> >> +            if (!cached_key) {
> >> +                    key_link(nvdimm_keyring, key);
> >> +                    nvdimm->key = key;
> >> +                    key->perm |= KEY_USR_SEARCH;
> >> +            }
> >
> > Ummm...  You're altering the key permission?  That's not really yours to
> > change.
>
> What can I do to allow the user app to look up the right key in order to
> pass the key id to sysfs? Without the KEY_USR_SEARCH I am not able to
> search for that key in the keyring.

I don't think you need to search. I would but NVDIMM_PREFIX into
include/uapi/linux/ndctl.h and userspace would need to know by
convention that for NFIT described DIMMs the piece after the prefix is
the ACPI NFIT unique-id. Other buses will need to have other
conventions, but I think it's fine to just document the convention as
"<prefix><bus-provider-specific-unique-id>", and then write up a
document of the known <bus-provider-specific-unique-id> formats.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
