Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B105B2194D3B8
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 10:56:41 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v10 02/12] ndctl: add passphrase update to ndctl
Date: Wed, 30 Jan 2019 18:56:39 +0000
Message-ID: <5126b5e8a22f78867761d0aca5e22e666fe2755c.camel@intel.com>
References: <154837084784.37086.4597479371733088393.stgit@djiang5-desk3.ch.intel.com>
 <154837123565.37086.2456954752128201392.stgit@djiang5-desk3.ch.intel.com>
 <1dc0a1788da54574257299d78006ab209639dc71.camel@intel.com>
 <CAPcyv4iNXDpbMeWOzyxHbAme4ZQ6aK-__Sq=TP7exLDhmQQ-Yg@mail.gmail.com>
In-Reply-To: <CAPcyv4iNXDpbMeWOzyxHbAme4ZQ6aK-__Sq=TP7exLDhmQQ-Yg@mail.gmail.com>
Content-Language: en-US
Content-ID: <95C0F89CCF48F041A52B34FF32D5B7BD@intel.com>
MIME-Version: 1.0
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2019-01-29 at 18:59 -0800, Dan Williams wrote:
> On Tue, Jan 29, 2019 at 6:35 PM Verma, Vishal L
> <vishal.l.verma@intel.com> wrote:
> > On Thu, 2019-01-24 at 16:07 -0700, Dave Jiang wrote:
> [..]
> > > +
> > > +The updated key blobs will be created by ndctl in {ndctl_keysdir} directory
> > > +with the file name of "nvdimm_<dimm unique id>_<hostname>.blob".
> > > +
> > > +OPTIONS
> > > +-------
> > > +<dimm>::
> > > +include::xable-dimm-options.txt[]
> > > +
> > > +-k::
> > > +--key_handle=::
> > > +     The new encryption key (master) key handle, used for sealing the DIMM
> > 
> > This doesn't read right. Maybe all of "master key" should have been in
> > parenthesis? Or the second 'key' is extraneous? (This applies to the
> > above man page as well).
> > 
> > > +     encrypted keys. The format is <key type>:<key description>.
> > 
> > Did you mean DIMM's encrypted keys? Or did you mean "used for sealing
> > (encrypting) the DIMM's keys?
> 
> For this exact concern I think the word "key" should be reserved in
> the documentation for only referring to the key-encryption-key used to
> generate / protect the encrypted passphrase material.
> 
> Yes, keyctl refers to the encrypted passphrase material as "keys" and
> "key blobs", but that's a keyctl internal concern. For ndctl, it's
> only concerned about the "key" used to generate a "passphrase". So the
> ask is to audit the man pages and make sure any usage of "key" is
> referring to the KEK and everything is else only refers to
> "passphrase", or "passphrase blob" etc.

Yes I think that makes sense and should clarify everything a lot!

> 
> > And is there one key that will be sealed, or multiple?
> 
> It could be one key for all passphrases, a key per passphrase, or
> anything in between. This is the motivation to follow on to this set
> with a capable configuration file that can record the
> key-to-passphrase relationship.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
