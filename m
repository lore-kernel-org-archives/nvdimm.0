Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05A62328A0;
	Thu,  6 Jun 2024 05:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717650142; cv=none; b=cu6myjqAmmXHuziR/DmLdPflGPzncMId4vE5FJzcGhHCijlGABZeS6uhfbZWYedSUpJq822RyxmdlRxLzbBLusGnt/p1Y9k0+An80mIABSGSocq5xnlYBEI0MLQRV+c4qi0/Nzt8fCXkto1XVThDDbYIwPDfWwxIZ6ERbA0KkZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717650142; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D79jmlYNFawq0+3ovLJxQLdiB3iwaKoo+ldGmvX/sADaDN3+4v3OWMJuL3CUimwhvM+LQWSTvC+BJfjbLb6Wy7jAan6B1V5rb1k2gvO7vtVHzlto4r8KDdd9diQhccDCsRvTR6Z3Taw9IrGpF8rqErGli7ajImF7SPR3MasQhkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lgncuOy7; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lgncuOy7"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-2544465c9e2so182985fac.2;
        Wed, 05 Jun 2024 22:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717650140; x=1718254940; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
        b=lgncuOy7KBOrB/GHRwOboxXk4HU0THwIzxTUwywBOjJ0zie70yczsVJnAPN5dTRLS3
         B+aHj/3v82cBBmNNrECbv73mcbZ5RTJWvtFWiagkSN4TaE1ZvS/Fqbrd2p3IyK6EZyV+
         yborEd9RJ6QhWYwUHKzCVDJ/Kb+mBuJ/w/VJgUhVKPcQUon8mgh9JZX7JeNJob6ak1iy
         Gg3Y36/B2cZ2lpcFZWHeTjhlD+xpuH7lH/2ot20TkZlXibaNWSRnaO6ZycHSUwEteWR3
         TpyOz6d6Q40V5cHigY7nPcGAJNC0svktQE9Xwiuz8IeJId717S3La8Jk2O8VuqzeRnqT
         21Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717650140; x=1718254940;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
        b=OxAVvmX6ozhwmREqQtBpgVQIrst9xOO7TAObcoSSCh0A1E91GKr6CwAnmV9paxd+ac
         7ovK8mmbssloGeCW7aOF3OBUPGvUtrUVgfYKCoOTvUj5Xhzbwup92vgNrpojs0mNzrpD
         HAwDEXrzVkmlKNqPOKgVRUCLEQtk59+5f5YOdpjPjLC2ltjuRQVortFzJsA2F7qozisL
         7xLr2abz8MJ5J5aHq4Z+iMF51Kj6xhOqSv330UjRa5yZoDyC3LXXirDzBhmuMIxM+6/5
         s4kZDb+/WFQjVuJKY/rLeHo6bOD15s8hDQ9bfbhoWIKIRQc7iy75UeRewIYPlBJDANGJ
         Gtfw==
X-Forwarded-Encrypted: i=1; AJvYcCWuPkdlUVDbYRUDry43kJBJDSnWpvoP0AKTSyWr87g+a8JwLSEFtsDbkFQJvTrXnQIUMdhnOBaQ1yXbWrFgDF4uhaMDtWyYI9hbUJSD0UPd0zc/Ybg56CiWx2MbDKY+qSs=
X-Gm-Message-State: AOJu0YzW89W7OumgFeAc+PL6y585FzvNcoS1MU058griJMMj/ZcMeFHz
	8cs4zmHd0rnnBf9vXrdy5IIoe7dKdzDEnSCR3S5Qv7gpIAZxxo8TFKnGeL7QwV4+cDnWhJ2WWut
	HuWe8eb33BJ1mZNyBCJEHE5HiBY4=
X-Google-Smtp-Source: AGHT+IHPqrwGLrOpiYOHRKHF6jjAJEe69uLlr8JRuR9rDqq7Rjpi5pT7mqAtKEV0L+JskZqRkbXl08yzChKNyWs0Mrk=
X-Received: by 2002:a05:6871:79c:b0:250:6be5:1fc5 with SMTP id
 586e51a60fabf-251228adf01mr5001314fac.38.1717650140012; Wed, 05 Jun 2024
 22:02:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240605063031.3286655-1-hch@lst.de> <20240605063031.3286655-4-hch@lst.de>
In-Reply-To: <20240605063031.3286655-4-hch@lst.de>
From: Kanchan Joshi <joshiiitr@gmail.com>
Date: Thu, 6 Jun 2024 05:01:53 +0530
Message-ID: <CA+1E3rKjG+kG1Z1N0c69Z_P5eNq9BzshKqdB5Ee0ySPzJGg-0g@mail.gmail.com>
Subject: Re: [PATCH 03/12] block: remove the BIP_IP_CHECKSUM flag
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai3@huawei.com>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
