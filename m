Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047E82FA62C
	for <nvdimm@lists.linux.dev>; Thu,  3 Jul 2025 18:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751568999; cv=none; b=fSD2mrTkPLfszN505JjzVK91ZBkfp9mXPJ99U5cafIvZXvodtaGFTePBhnghMLNNmeSwgx3NQjWYWaj4mP0gew2XWKIdt3qlEkAZBGtfYU4gXZQKaoY5f4suA23MnyV9ICruiYVhirxNIueqT8nBQUfuN1WcSrrCnisbRL8i/uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751568999; c=relaxed/simple;
	bh=UQAZ8zLttUZ8DRuWxXbltVWRlFbP9bIAenJaMLe7WlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sgx2fVobCgCVgEPIlDWC2L6U3wtdAh35HHBhb7FcKGtqcdFSYtZkISf1K1HxyUYJ6z8IihWclkXk7xVhjfWJeHRZfCeEd5xd5t1uR+PH7o3SGBKnQCxwpSzc7qxHZa+J9qeNxsgKH5+V0JACb/K479K4qDKgx6oqMBWhvzew0Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VRapJaiM; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VRapJaiM"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-40abe6f8f08so231069b6e.0
        for <nvdimm@lists.linux.dev>; Thu, 03 Jul 2025 11:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751568997; x=1752173797; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I0B3UqBqQulOzfupGyjVu5okNK2LnOMOlDR/fz/GO0Y=;
        b=VRapJaiMoms4hmXmAK1qIhU8TgLBHUWWYQlccS5nXL9eXcB7RBxYqY0YKxlk/p7kDi
         X3L+eQa0k4fffP+ILU3ztes1KQzdlL5vzx1msOc61tyTr6FU9Jw1WXR8NIQz7BpAH1C2
         Krf/0cVImcJUKHnQn3MrE+A41KXcHzebS+n/8Dpuwt7B3nA54imfiYVWsEN+2kKNf/o/
         6+2MypoJzjUNyEX2eafArI3G1uwqm+E7ScQpapQoUrs1Jgpoymg1W0Ya2m+PoxLl+kJm
         ixSEWLbg7nnf9FihzurzHvXxZIgHA5BJGwtPAZnjNqodYP/u0Ng6876goPXN7oQlzx70
         naKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751568997; x=1752173797;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I0B3UqBqQulOzfupGyjVu5okNK2LnOMOlDR/fz/GO0Y=;
        b=N3W9uKKyzO9PTaDtnLx2vG2OeCyFPAxK6wi0m/+w3NKijQIIh6Oxo8AAnhg+mh9XnY
         86Pja3sUxtm7p2xFAvZRMJkQW6xEAIz7SEC+sPUw7QtR+0VF9oAHo+zugEzLS8kD2YFg
         9yMadWVn/Roj4cFqA9849YwxiYPY5AwsCCzYre8ZI3MptAMmo1gqleKvTpsNcDDQdc2Y
         0N7GTFIF/Rf5O/3yZ0Ar9JqrKgxkC9ZA4wz0A38gnEvpllpvjgWM8NYYTHnNtbMTO5sA
         a1QAACxtaqiGVFu0c7V6D8j0OVTWvR322UjscDTAvoRs+a41P3FtyGjbnvS2ap65sLQE
         bKbw==
X-Forwarded-Encrypted: i=1; AJvYcCUoSgH5UFtzfpJMB1lsC90/8XD9K5Ipcj9O1oZzK5GN6n4/e0p/vlZeEajqImKCNGXgTtH6b1w=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRdMLcilB+2rA5EzjKwBRu+AvmstJNZ0ylTFh8exmkrML1pTaZ
	kZdkjINqFkvkfTzfWlKUeDBMQmm2Y4Rv8AvlLmKeVC46X9EHS9o6PdeiUp09J6DZ
X-Gm-Gg: ASbGncsul6Yah3dD6x2qROBYhZS34gnQPdGGw3rRp9nu0TeIp8Sj7fOFFywyiqOw6aS
	pD6nsa0sOL38oiNBgAtX4lzi/JSiD25pu8Tf6EN6XQI3h/xu8eWsiSyXJmYf9w3dvICS12jN1H6
	W39fTApvxWpXmkv1dhnEgKyZkLjqZoww4F0h+TL3/fEaY7mxSBD0JEXU5K1Z3lQdCF4mbK3ugFg
	D6AGzW9L67xrivaY9r6dpgPT+30k/J5Gr3OMP49Wr/iGrJ5DuKHHwY+TXyIfi5tm9fsy2U/6gO7
	456t9w24gYi1DJYL+uIiW8KRICnG/OkLYeDYXXpnBNDrniEdgwEUe2/Rw6mtIbTMq4Fr5+S3UFy
	ZPL4rFhjQeg==
X-Google-Smtp-Source: AGHT+IGASt9BPy2PeX5NaYh3/reWzvowDb/acQvtLTw6FIrvDHn+1U14JqW0DXZlujFkHDKYOQyFWA==
X-Received: by 2002:a05:6808:1919:b0:40a:a3a6:9179 with SMTP id 5614622812f47-40b8932fcc8mr7044822b6e.39.1751568997047;
        Thu, 03 Jul 2025 11:56:37 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:cd4:2776:8c4a:3597])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-40d02ae4172sm29988b6e.45.2025.07.03.11.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jul 2025 11:56:36 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 3 Jul 2025 13:56:34 -0500
From: John Groves <John@groves.net>
To: Dan Williams <dan.j.williams@intel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Bernd Schubert <bschubert@ddn.com>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 00/18] famfs: port into fuse
Message-ID: <os4kk3dq6pyntqgcm4kmzb2tvzpywooim2qi5esvsyvn5mjkmt@zpzxxbzuw3lq>
References: <20250703185032.46568-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250703185032.46568-1-john@groves.net>

DERP: I did it again; Miklos' email is wrong in this series. 
Forwarding to him...

John

