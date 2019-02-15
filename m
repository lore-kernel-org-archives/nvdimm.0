Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D27F208AE34C
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 01:57:13 -0800 (PST)
Date: Fri, 15 Feb 2019 10:57:12 +0100
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [LSF/MM TOPIC] Software RAID Support for NV-DIMM
Message-ID: <20190215095710.GA12279@linux-x5ow.site>
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
To: lsf-pc@lists.linux-foundation.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, hare@suse.de, linux-btrfs@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

(This is a joint proposal with Hannes Reinecke)

Servers with NV-DIMM are slowly emerging in data centers but one key feature
for reliability of these systems hasn't been addressed up to now, data
redundancy.

While it would be best to solve this issue in the memory controller of the =
CPU
itself, I don't see this coming in the next few years. This puts us as the =
OS
in the burden to create the redundant copies of data for the users.

If we leave of the DAX support Linux' software RAID implementations (MD,
device-mapper and BTRFS RAID) do already work on top of pmem devices, but t=
hey
are incompatible with DAX.

In this session Hannes and I would like to discuss eventual ways how we as =
an
operating system can mitigate these issues for our users.

Byte,
	Johannes

-- =

Johannes Thumshirn                            SUSE Labs Filesystems
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
