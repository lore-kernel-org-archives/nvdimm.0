Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1EC6121160A36
 for <linux-nvdimm@lists.01.org>; Sun, 11 Nov 2018 11:20:47 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id u130-v6so5500621oie.7
 for <linux-nvdimm@lists.01.org>; Sun, 11 Nov 2018 11:20:47 -0800 (PST)
MIME-Version: 1.0
References: <154180093865.70506.6858789591063128903.stgit@djiang5-desk3.ch.intel.com>
 <154180163666.70506.8805433934495072699.stgit@djiang5-desk3.ch.intel.com>
 <1541957268.3734.53.camel@linux.ibm.com>
In-Reply-To: <1541957268.3734.53.camel@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 11 Nov 2018 11:20:34 -0800
Message-ID: <CAPcyv4jMPDap8L6jTo9NGnrJGCjUY_BvSBuPge8NL4QS2Ku0CQ@mail.gmail.com>
Subject: Re: [PATCH 02/11] libnvdimm/security: change clear text nvdimm keys
 to encrypted keys
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
To: zohar@linux.ibm.com
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, keyrings@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

[ add keyrings and lkml ]

On Sun, Nov 11, 2018 at 9:28 AM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> On Fri, 2018-11-09 at 15:13 -0700, Dave Jiang wrote:
> > In order to make nvdimm more secure, encrypted keys will be used instead of
> > clear text keys. A master key will be created to seal encrypted nvdimm
> > keys. The master key can be a trusted key generated from TPM 2.0 or a less
> > secure user key.
>
> Trusted keys also work for TPM 1.2.  Are you intentionally limiting
> the master key to TPM 2.0?

TPM 1.2 is supported from a software perspective, however the
intersection of hardware platforms deploying security enabled NVDIMMs
and TPM 1.2 might be a null set.

> Traditionally there is a single master key for the system, which would
> be sealed to a set of boot time PCR values.  After decrypting all of
> the encrypted keys, the master key would be removed from the keyring
> and a PCR extended.  Extending a PCR would prevent the master key from
> being unsealed again and used to decrypt encrypted keys, without
> rebooting the system.  Normally this would be done before pivoting
> root.
>
> If you're not referring to the system master key and are intentionally
> limiting usage to TPM 2.0, more details on the master key security
> requirements should be included.

Oh, interesting point. I think we had been assuming a local +
unsealed-at-runtime nvdimm master key rather than a system-wide master
key. Yes, we need to rethink this in terms of supporting a sealed
system-key. This would seem to limit security actions, outside of
unlock, to always requiring a reboot. I.e. the nominal case is that we
boot up and unlock the DIMMs, but any subsequent security operation
like erase, or change-passphrase would require rebooting into an
environment where the system-master key is unsealed. I do think
re-provisioning keys and erasing DIMM contents are sufficiently
exceptional events that a reboot requirement is tolerable.

Is there already existing tooling around this to be able to schedule
master-key related actions to be deferred to an initrd environment?

> Using trusted keys that are encrypted/decrypted using a user key
> should really be limited to testing environments.

Makes sense.

> >
> > In the process of this conversion, the kernel cached key will be removed
> > in order to simplify the verification process. The hardware will be used to
> > verify the decrypted user payload directly.
>
> Making this sort of change implies there is no concern in breaking
> existing userspace.  Either the code hasn't yet been upstreamed or
> there are not any users. If the code hasn't been upstreamed, it would
> make more sense to squash the git history:
>
> - making code review easier
> - making the git history bisect safe

Yes, the old scheme is not upstream. I'll do the squash once we've
finalized the key-management details.

Thanks for the help Mimi.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
