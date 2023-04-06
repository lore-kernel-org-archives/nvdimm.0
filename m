Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E22AD47
	for <nvdimm@lists.linux.dev>; Thu,  6 Apr 2023 19:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Bfc4MoxW69RqNoXmXDlX2wXhjgD6wTy+Du4f8wMhNOE=; b=RE4JvnuJdOiiDzo0+bGjHnNo8o
	I6MtnTr/k0Ih20Bvw9bFO/5JvApWU62xkw99vBbM6QWwWu1HVZEhkqoyKQd9WQUHF6Kzj9lGQB1R1
	+6t8JcfR5MArG0S392L8bEZMc+3VYIMvTxRugU33+7MJXAU9XmZNBTWPQGkpieCGM7zrzmWyyi1y1
	QFP+8KAjxrWcrdXBhjb3Cq1AdjOuc4IsJsYAR762hDGqGjPgUve0LFO12p85AO7uFV/ISZWKnhXuM
	itpaxJGD/QJP8vj1wIbJlnzNdWG3mJqCx9Vf3s5PBaEcWnaIgiEmP8qylqSj60AX4AIFoA26Dxyw+
	Q0wohHrQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pkVLa-0006Gh-H3; Thu, 06 Apr 2023 19:32:38 +0000
Date: Thu, 6 Apr 2023 20:32:38 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: dan.j.williams@intel.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, ira.weiny@intel.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] dax: enable dax fault handler to report VM_FAULT_HWPOISON
Message-ID: <ZC8eVmF7YdBsDmc4@casper.infradead.org>
References: <20230406175556.452442-1-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406175556.452442-1-jane.chu@oracle.com>

On Thu, Apr 06, 2023 at 11:55:56AM -0600, Jane Chu wrote:
>  static vm_fault_t dax_fault_return(int error)
>  {
>  	if (error == 0)
>  		return VM_FAULT_NOPAGE;
> -	return vmf_error(error);
> +	else if (error == -ENOMEM)
> +		return VM_FAULT_OOM;
> +	else if (error == -EHWPOISON)
> +		return VM_FAULT_HWPOISON;
> +	return VM_FAULT_SIGBUS;
>  }

Why would we want to handle it here instead of changing vmf_error()?
