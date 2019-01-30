Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 53B5A211B1115
 for <linux-nvdimm@lists.01.org>; Tue, 29 Jan 2019 19:00:09 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id m6so18009785oig.11
 for <linux-nvdimm@lists.01.org>; Tue, 29 Jan 2019 19:00:09 -0800 (PST)
MIME-Version: 1.0
References: <154837084784.37086.4597479371733088393.stgit@djiang5-desk3.ch.intel.com>
 <154837123565.37086.2456954752128201392.stgit@djiang5-desk3.ch.intel.com>
 <1dc0a1788da54574257299d78006ab209639dc71.camel@intel.com>
In-Reply-To: <1dc0a1788da54574257299d78006ab209639dc71.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Jan 2019 18:59:57 -0800
Message-ID: <CAPcyv4iNXDpbMeWOzyxHbAme4ZQ6aK-__Sq=TP7exLDhmQQ-Yg@mail.gmail.com>
Subject: Re: [PATCH v10 02/12] ndctl: add passphrase update to ndctl
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 29, 2019 at 6:35 PM Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Thu, 2019-01-24 at 16:07 -0700, Dave Jiang wrote:
[..]
> > +
> > +The updated key blobs will be created by ndctl in {ndctl_keysdir} directory
> > +with the file name of "nvdimm_<dimm unique id>_<hostname>.blob".
> > +
> > +OPTIONS
> > +-------
> > +<dimm>::
> > +include::xable-dimm-options.txt[]
> > +
> > +-k::
> > +--key_handle=::
> > +     The new encryption key (master) key handle, used for sealing the DIMM
>
> This doesn't read right. Maybe all of "master key" should have been in
> parenthesis? Or the second 'key' is extraneous? (This applies to the
> above man page as well).
>
> > +     encrypted keys. The format is <key type>:<key description>.
>
> Did you mean DIMM's encrypted keys? Or did you mean "used for sealing
> (encrypting) the DIMM's keys?

For this exact concern I think the word "key" should be reserved in
the documentation for only referring to the key-encryption-key used to
generate / protect the encrypted passphrase material.

Yes, keyctl refers to the encrypted passphrase material as "keys" and
"key blobs", but that's a keyctl internal concern. For ndctl, it's
only concerned about the "key" used to generate a "passphrase". So the
ask is to audit the man pages and make sure any usage of "key" is
referring to the KEK and everything is else only refers to
"passphrase", or "passphrase blob" etc.

> And is there one key that will be sealed, or multiple?

It could be one key for all passphrases, a key per passphrase, or
anything in between. This is the motivation to follow on to this set
with a capable configuration file that can record the
key-to-passphrase relationship.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
