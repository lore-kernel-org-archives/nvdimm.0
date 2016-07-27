Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C441F1A1E0F
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jul 2016 03:35:13 -0700 (PDT)
Date: Wed, 27 Jul 2016 12:35:05 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: HPE SMART data retreival
Message-ID: <20160727103505.ovq7jz4553s7kc42@c203.arch.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan and Jerry,

I'm currently looking into SMART data retrieval on HPE NVDIMMs.

After the first obstacle (like getting cat
/sys/class/nd/ndctl0/device/nmem0/commands reutrn smart so ndctl will issue
the ioctl) I ran into a rather nasty problem. According to [1] HPEDIMMs
need the input buffer specially crafted for SMART data, according to [2]
Intel DIMMs don't.

Adding translation functions for the DIMMs accepted commands is one thing a=
nd
should be more or less trivial for all DIMMs (I'll post an RFC patch as soon
as Linus merged Dan's 4.8 pull request so I can rebase it) but doing this
type of conversation for each and every command for every defined vendor
family for both the input and output buffers will drive us all mad I guess.

Especially from the distribution's POV I'm not to keen on having customers
with some new NVDIMM family and we would need to re-implement all the
translators again. Adding a new ID is one thing but translation tables are a
totally different story.

So the question is have I overlooked something and there is a clean and easy
solution to this problem, or not.

@Jerry have you tested SMART data retrieval with ndctl? Did it work for you?

Thanks,
	Johannes

[1] https://github.com/HewlettPackard/hpe-nvm/blob/master/Documentation/NFI=
T_DSM_DDR4_NVDIMM-N_v84s.pdf
[2] http://pmem.io/documents/NVDIMM_DSM_Interface_Example-V1.2.pdf

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
