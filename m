Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA84338422F
	for <nvdimm@lists.linux.dev>; Tue, 21 Apr 2026 22:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776809644; cv=none; b=NZIckreGJh68wqOVM10hA4uV34ICm9ldsx+IHJcpki6WUV7CgG50bj25VS+9gX9ZIsJgdr19G7OS3rWMubTYfgXVuudmLa6dL4ZymucNzZOU552LLe5yJinzaV/YZTBm5V8LXsrzs4lLr/QrcvN+KgSxYq7UHoe2j+4EWmiXvXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776809644; c=relaxed/simple;
	bh=Iu5XAN4ycbBpopEF1eWkcWzsBYF1UWk4/bNXchE4nLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=isEXRfO5wEDN6GGx2BHaf3BolWT/axLus0l/TLUeOr0X85DBRsxUtY64pNcpQo7XlPSmLC0/wkKefolWKS0ecNm2Nwoa39dCy7S4vmb7lc+XINf+5RB8hvStGx2WmSyl8JykJMjFS4LpL48Xo2D7bUvyC0P4LLXReEyIxNwJ5KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=a15eOeBy; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="a15eOeBy"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cb40149037so484494385a.2
        for <nvdimm@lists.linux.dev>; Tue, 21 Apr 2026 15:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776809642; x=1777414442; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wrGysjxDZE2kLSR6t5QtYa+yFecZADsz4QmGJDAHoGE=;
        b=a15eOeByczTxEkG9YIO0APiXBqiiJ8ctzBxTTl4/0RLNsZyIJwTY7lU5tAbVDKMh9s
         Zd5gOccsqRJ/+XS25BVgxEva7iwcTWWURUaBaCa1qsyfmIRben+WzowbuvuNokmNJ7MU
         F8rZ4KluENstYUcsZ/ICIMOMTmOu136xIXLQK3ly2G6tyA6j1kPibV4VmzCRBq+PQbbl
         2Vl/4sxJDBXasO8ETBb2j2kjzSp/ycnL6Fjwv/eYnHZBiC3UUoCuIbg+pElm5FcKLTsy
         1OdIoL2RGm6DaM/phg01awDqviaKdpTYL0QRiy1SoyenPN/PXVs8i/FQTWDsOBd/vovM
         YWbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776809642; x=1777414442;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wrGysjxDZE2kLSR6t5QtYa+yFecZADsz4QmGJDAHoGE=;
        b=c0xl2nT0az3w0iMhSKRwhHbsW10eUfh+OfI/QSgkuTquO+z95pd+jRDYV14FynLZ39
         u4u8q3Wuwhn92MJC7J0NUdy0fg5oQAX9K7VHN45va5hoAdT2A4LB9SHXbvy6wpumcPc8
         kZBSwJw2xOienxTdE35z23CpK4dCOpdz9Gk2Wlcn98J9dSvz3gWUKH3i8/g03IubqrNG
         FHPWf9YYaVH2t3Zbisi2l8Kca8C82sYjpiZf1U9nUFZ3+04BwomOngukjoii1uBFhUbV
         Kz9mCOIwUs5EnIJYaBCwduga6MQLuUuKeK/2zo7zFcfSEcPI/HoQQCGaZEtE2PywWqXt
         +Zzg==
X-Forwarded-Encrypted: i=1; AFNElJ8+T7yGzJs52W+EsQis/CWculGaHsjrJ/IXzszUaA3ZIiWu592Z7ePzc5WJSqv7h/Ic2IDMAmo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwB0KKwv/yQJGKmTgmR0vtMiOKJ4ARQ7bRx5sEPw3yc+lHFwFa9
	h2h+bvbKA5/WsZYfV1RxaFt5A6sThMVP1dVCQqSzSFH8Ni/qAxa7bkCEFKI8hmp8gIk=
X-Gm-Gg: AeBDiesoxg1Wylg8GYZ6FBm9WdiEyknwNsEOE7y5XYdsEfAVcPSuPKsIPDKNuO2pksy
	nLGfXSVMlZWLKRDvLvy0Xwvd3nrG82roFmr4P7USj+I9N7IVh+e8kPF5enf35Sgzs0T8vgEUfB+
	8jgTIzITYdI76ufv3UVceRSqWPqbqCPAV4jvaOI3m4BJc5c0PG4+cgHz5085F2nYaYuIbqgX9k4
	NA5nO747LsR5RJSek5EYIiONn+qM7vtF1mrF3qEgp6+zUGZDIsj3uCz/KH0qOvZZwDMFzvSFE0/
	2HBoiVCmuw29+B2GPKjj+3jD7Qxyv48LM56cVrKDSfZovHuq7VQbIMx0vU6sVgPWgOhu9AFtYz3
	ZWe2XCpUqyqImjZpyoy6cR3eFSd/An4NJPW7yT8WSvGC+2fQ28kF4vmepxR0nbAsiEluzGFNlH8
	ru7CTpKsEA8mZZ2wWucZUo4rmwTsZ3W4PSViSfREz2Y1TQXpCe20d27E3742ifrbK9Xyr1+CjSE
	fOgal0GW7wwBZxhBMM5
X-Received: by 2002:a05:620a:2844:b0:8cf:c1c2:90f with SMTP id af79cd13be357-8e78fa1ebc4mr2786943085a.7.1776809641667;
        Tue, 21 Apr 2026 15:14:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-246-228-50.washdc.fios.verizon.net. [71.246.228.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ebce6ef86dsm515161085a.30.2026.04.21.15.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:14:00 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:13:58 -0400
From: Gregory Price <gourry@gourry.net>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: John Groves <John@groves.net>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Bernd Schubert <bernd@bsbernd.com>,
	John Groves <john@jagalactic.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	"venkataravis@micron.com" <venkataravis@micron.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	djbw@kernel.org
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <aef2pvhIEdvvgfDF@gourry-fedora-PF4VCD3F>
References: <CAJfpegvVTcV89=q3L326aGQjhduBcv7PVg5QKftGLjNZmCLmaw@mail.gmail.com>
 <ad4_jFsR951c2Mtn@groves.net>
 <20260414185740.GA604658@frogsfrogsfrogs>
 <ad69tTnx5YkD4Y9K@gourry-fedora-PF4VCD3F>
 <f254f6fc-dc06-4612-82d7-35bb10dbd32e@kernel.org>
 <aeUU8hMwPij2WvfF@groves.net>
 <aeVy2MzucnrLlOQx@gourry-fedora-PF4VCD3F>
 <CAJnrk1ZpPS9rOoBqOBRsqTu0Zgk=aoYzpYZ0mAVDCoeewtLhcg@mail.gmail.com>
 <aeeJ8Lgg2z0X-NC_@gourry-fedora-PF4VCD3F>
 <CAJnrk1Zd2RFE=z=sPRCHaBdqK40+23Vv_owS=7OfxYF1TtPomg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1Zd2RFE=z=sPRCHaBdqK40+23Vv_owS=7OfxYF1TtPomg@mail.gmail.com>

On Tue, Apr 21, 2026 at 11:59:15AM -0700, Joanne Koong wrote:
> On Tue, Apr 21, 2026 at 7:30 AM Gregory Price <gourry@gourry.net> wrote:
> 
> I'm not sure if this addresses Christian's concerns or not, but the
> blob would reside within struct fuse_inode not struct inode. I
> definitely agree with him that this should not touch or add any infra
> outside fuse.
> 
> I hadn't heard of bpf arenas until his comment. If the hashmap
> overhead is too high for famfs, having a custom in-arena hash table
> would be much faster I think, as it could be designed to require less
> pointer chasing and avoid other overhead in the bpf hashmap
> implementation, though now famfs would have to manage the data
> structure and complexity itself.
> 

I think if the fuse-inode blob is acceptable, that's highly preferable -
and it wouldn't necessarily need to stay specific to bpf.  If there was
some generic format that folks agreed on as a baseline, that could
obviously be worked into the interface.

~Gregory
