Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7375E52CCC1;
	Wed, 14 Oct 2026 14:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791987321; cv=none; b=g0/3+w0KKv8OKhPTwAl0p9AdRgDS2na50Aubu7DVO5+BBPZHK8brfK8ejTvgXDZERHbbFwh7xgAQSVPnwnV0iPDPZrmaZyNxmOqARPDcC5VJM2XVxxVL+x63NoGUfTtRh3AtFN5Xtk+f1hcRhm4WIGZiBJpVirx0u3m+maf53og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791987321; c=relaxed/simple;
	bh=UU3mFXTLy83MYf/mMEoPutZdlb7NNRuCLxuZHFSIijs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=vDrfSCpLP10RJ//re/XNB/mqax5sioUUpi+LTS45/TLeACX0issifY1gj2B2G4WUe/EJJECFuiets7wYfhyKcYD4zysMLg/E+ss6nSb7hCNjY9c+lGiTSW3tzmEcLa11UXFI/kYz1sqZCe6pMtORz8XDgFp88857dRoN/f/kMGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 27AC340599;
	Wed, 14 Oct 2026 14:15:17 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf13.hostedemail.com (Postfix) with ESMTPA id 054AE2000E;
	Wed, 14 Oct 2026 14:15:14 +0000 (UTC)
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 66C5CF40066;
	Wed, 14 Oct 2026 10:15:14 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-09.internal (MEProxy); Wed, 14 Oct 2026 10:15:14 -0400
X-ME-Sender: <xms:co7PalV1fpGDZFSURc_CRtHZJZpihKCG-a-v2Y8qKAjA5M41m2vCvg>
    <xme:co7PagYnLUz6PByAUo4K_tbhh4Knkgjn6Rnda2zYlkpPaJtwfozvQMQhgt8xBFfT5
    3nmQ5R0wnJFFDZhSgCbe-kE0q5_o1c1YV6GiVoPg36axSmSSoeKoA>
X-ME-Proxy-Cause: dmFkZTEd/BP7YPzQpwVymWCLCz5d7z8cPfoYJOKlkSu6IDfRIYKsXnldzG2Zj7V4cHGGaC
    19beiY+SNOekCX4W9Yc3R6rfa+Z9aOeARhjQo65W5BR03tEOuwoXCSCqBJDgdwEO4mB6qz
    JoZ8MnGQpveO0a7prAFr1Yk82SUnjkGW786yQSg0655Umc8gVSiLioddv6pK5rKbM7e6VW
    aXp0CUBbmajRjaTYeoZe1KyWdwCo/EVprduIxftKjZauwiQONAPRRjQeGqk8tihqW/6akH
    NseT1HnlGiF8F7uTGNFBS6J0vL6DmHEllHvlJ7lk5ZZHThxLG9zXdNVctbsdJgNq2bojfQ
    vy/U/N07ATXIN1p6Uo+BcjZrU2RK9PKXn1b3uWxb4QkUmZI2YW3BQJvJpx3tiOXWVwZV/z
    eZZoWBBdmcyPm0vBDe4acrhMicUBS9P7SjUNs3uc+wwnvWuLf+7xA7w/Swo+W3DC6B1atq
    BKgqf3E4ZWHkHFcLXRxhZdhnx6/9Zss111JykP9LoowAvZhsqV5B9AAnG7/pl6TCkhj2do
    cnewAxBUAZIc5JVkP+Q2c2WGpoMLXjTjn2tpf0fVuMVpsXYdbbe8tsklqClgm2PkAESnYu
    YiOMEWQjR4YtU2DnOFtoU3opN8RHaN7iQRoUhOhppVoTsuReOJ0DS2u//WfQ
X-ME-Proxy: <xmx:co7Pat7CR7wKr05wTgZT6JJB0iDvAjiUgxUm_VZSiAedXCg0WUGdbg>
    <xmx:co7PajF9u45HMNAPAOQTUosBTZ2F6zmd7EOKq9EuiS0rpt2W75iAbQ>
    <xmx:co7PagAW9ajh0ecp8pLZW5tgFdiAW3G8fJWavhNuuiAIfxYdiuIRlQ>
    <xmx:co7PagzklsxtlCKQt72lTFqh4nYWXSu5ic0DbMn2sXMn0fsuhJe_Dw>
    <xmx:co7Pas4kgEdsQYOD_K0BNkQ-eDZ0u_LBTjFfZh0C8DxcxYSIzRxxXRK2>
Feedback-ID: i3a164872:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 3A34A700065; Wed, 14 Oct 2026 10:15:14 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 14 Oct 2026 09:14:54 -0500
From: "John Groves" <john@groves.net>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Cc: "Miklos Szeredi" <mszeredi@redhat.com>,
 "fuse-devel@lists.linux.dev" <fuse-devel@lists.linux.dev>,
 "Amir Goldstein" <amir73il@gmail.com>,
 "Darrick J . Wong" <djwong@kernel.org>,
 "Vishal Verma" <vishal.l.verma@intel.com>,
 "Dave Jiang" <dave.jiang@intel.com>,
 "Alison Schofield" <alison.schofield@intel.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Message-Id: <f9bdb2ef-33d7-4601-87fc-354a9e753141@app.fastmail.com>
In-Reply-To: 
 <CAJfpegvDbGaoH5Er78M=XYwA6a7zj6DRqY0+F0cgiD7TfRK_Mg@mail.gmail.com>
References: <20261008112004.1899560-1-mszeredi@redhat.com>
 <aswN-UprZHx9wU9y@groves.net>
 <CAJfpegvDbGaoH5Er78M=XYwA6a7zj6DRqY0+F0cgiD7TfRK_Mg@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] fuse: resolve extent maps in O(1) when possible
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 054AE2000E
X-Stat-Signature: 1n6ppyhqociuseudaatqnbcpe44p8ice
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX18/oRjGa/Rn4DQEBtZlEm+EmmatrJ+ZgvU=
X-HE-Tag: 1791987314-722773
X-HE-Meta: U2FsdGVkX1+5aVdf5QXr+1pa4v9ZvbCJDt2JPLBRCFmYLCSA2UHI5PaCp8iduF3lYe8EVjodyZNeOvNtjHKFiy873Ov6zosHDlAczBdHbQgQA1ME+uCggeiLP/GuLqMXclyETSGodR9bR9gtSTfRPN04PP6QqxMmhmez/OGcigoFFJVc+AsK89DJUeeI1UDFw1+ns8jSGXML1tll0gH1lLbI2gqJ0LH688kmwdTi9NvmfNTjPFnj80L3ykvF7ANEH9D7lhmR8FtDBVw+nRD2+oEvNdyBeUMMyR8w5RvW6xHX0F1C7eVQvEsUw3OctImmkMZx2pf+h6QjIkFKGNGCJynkyhFbdh2ArAlPv6LqzdfCJU7qxqnP04KHB4e8+WoU



On Wed, Oct 14, 2026, at 4:40 AM, Miklos Szeredi wrote:
> On Mon, 12 Oct 2026 at 00:33, John Groves <john@groves.net> wrote:
> 
> > With this patch on top of v4 the famfs test suite passes; that tree is
> > at [2].  The famfs userspace master branch [1] now works with v4.  If
> > the next revision needs further userspace changes, please base them on
> > that branch or send them my way so the two don't diverge.
> 
> Applied, thanks.

Thank you!

> 
> Please next time use a new mail thread, because linking to the old one
> confuses b4.

Will do, thanks

> 
> Thanks,
> Miklos
> 

John
