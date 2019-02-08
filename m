Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 777C1211BFCC5
 for <linux-nvdimm@lists.01.org>; Fri,  8 Feb 2019 01:02:48 -0800 (PST)
Date: Fri, 8 Feb 2019 10:02:45 +0100
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [LSF/MM TOPIC] The end of the DAX experiment
Message-ID: <20190208090245.GA8038@linux-x5ow.site>
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <d7790ae27161db2fcf0b10a7d5d67de833f2d3fe.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d7790ae27161db2fcf0b10a7d5d67de833f2d3fe.camel@hpe.com>
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
To: "Kani, Toshi" <toshi.kani@hpe.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 07/02/2019 22:51, Kani, Toshi wrote:
> I've also had multiple users complained about 'mount -o dax' succeeded
> by falling back to non-dax despite of their intent.  Such users wasted
> many hours without knowing their setup error / current restrictions.
> The next think they always ask is how to check if dax is enabled in such
> case, and they are not happy about limited interfaces (ex. look for
> mount entry in /proc/mounts), either.

Exactly, there's a need for admins and user-space applications to check if =
they
can use DAX or not. See also [1] for reference.

> Same as above.  Such enhancement should be possible after EXPERIMENTAL
> is removed from 'mount -o dax'.  IOW, a separate EXPERIMENTAL message
> can be shown when user requests per-directory dax.

Just as a data point here, in our Kernels we've removed the EXPERIMENTAL
warning for DAX on XFS (but not EXT4) and we are supporting it for some lim=
ited
use-cases.

[1] https://lore.kernel.org/linux-fsdevel/20181002100531.GC4135@quack2.suse=
.cz/

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
